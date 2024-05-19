//
//  AddNewCategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol AddNewCategoryServiceProtocol {
    func createNewCategory(with category: CategoryModel, image: UIImage?) async throws -> String
}

final class AddNewCategoryService {
    private enum Constants {
        static let imageLink = "imageLink"
    }

    private init() {}
    static let shared: AddNewCategoryServiceProtocol = AddNewCategoryService()

    private let imageManager = ImageManager.shared
    private let dataBase = Firestore.firestore()

    // swiftlint:disable line_length
    private let defaultImageLink = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2F1E1922CE-61D4-46BE-B2C7-4E12B316CCFA?alt=media&token=80174f66-ee40-4f34-9a35-8d7ed4fbd571"
    // swiftlint:enable line_length
}

extension AddNewCategoryService: AddNewCategoryServiceProtocol {
    func createNewCategory(with category: CategoryModel, image: UIImage?) async throws -> String {
        let uploadCategory = try await postCategory(with: category, image: image)
        try await addDocumentToFireBase(dict: uploadCategory)
        guard let newCategory = uploadCategory["imageLink"] as? String else {
            print("[DEBUG]: Не удалось создать категорию")
            throw NetworkError.unexpected
        }
        return newCategory
    }

    private func postCategory(with category: CategoryModel, image: UIImage?) async throws -> [String: Any] {
        guard let userId = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }

        var categoryDict: [String: Any] = [
            "title": category.title,
            "createdDate": category.createdDate,
            "linkedWordsId": category.linkedWordsId,
            "isDefault": category.isDefault,
            "profileId": userId
        ]

        if let imageLink = category.imageLink {
            categoryDict[Constants.imageLink] = URL(string: imageLink)?.absoluteString
        } else if let image = image {
            let imageUrl = try await uploadCategoryImage(with: image)
            categoryDict[Constants.imageLink] = imageUrl.absoluteString
        } else {
            categoryDict[Constants.imageLink] = URL(string: defaultImageLink)?.absoluteString
        }

        return categoryDict
    }

    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }

    private func addDocumentToFireBase(dict: [String: Any]) async throws {
        do {
            try await dataBase.collection("categories").addDocument(data: dict)
        } catch {
            throw error
        }
    }

    private func uploadCategoryImage(with image: UIImage) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let imageRef = Storage.storage().reference().child("categories/\(UUID().uuidString)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"

            guard let imageData = image.jpegData(compressionQuality: 0.2) else {
                continuation.resume(throwing: NetworkError.unexpected)
                return
            }

            imageRef.putData(imageData, metadata: metadata) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    self.downloadURL(from: imageRef, completion: continuation.resume)
                }
            }
        }
    }

    private func downloadURL(from imageRef: StorageReference, completion: @escaping (Result<URL, Error>) -> Void) {
        imageRef.downloadURL { url, error in
            if let url = url {
                completion(.success(url))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}

private extension String {
    static let imageLink = "imageLink"
}
