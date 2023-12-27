//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol CatalogNetworkManagerProtocol {
    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
    func loadCategories() async throws -> [CategoryApiModel]
//    func postCategory(with category: CategoryModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CategoryService: CatalogNetworkManagerProtocol {

    static let shared: CatalogNetworkManagerProtocol = CategoryService()

    private let imageManager = ImageManager.shared
    private let dataBase = Firestore.firestore()

    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        completion(.success(MockData.topFiveWords))
    }

    func loadCategories() async throws -> [CategoryApiModel] {
        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection("categories").getDocuments { querySnapshot, error in
                if let error = error {
                    print(error)
                    continuation.resume(throwing: error)
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    continuation.resume(throwing: NetworkError.unexpected)
                    return
                }

                let categories: [CategoryApiModel] = documents.compactMap { document in
                    do {
                        let category = try document.data(as: CategoryApiModel.self)
                        return category
                    } catch {
                        continuation.resume(throwing: error)
                        return nil
                    }
                }

                continuation.resume(returning: categories)
            }
        }
    }

    // FIXME: - эти методы пойдут в AddNewCategory
    func createNewCategory(with category: CategoryModel) async throws {
        let uploadCategory = try await postCategory(with: category)
        let dict = uploadCategory
        try await addDocumentToFireBase(dict: dict)
    }

    private func postCategory(with category: CategoryModel) async throws -> [String: Any] {
        return try await withCheckedThrowingContinuation { continuation in
            uploadCategoryImage(with: category.imageLink) { result in
                switch result {
                case .success(let imageURL):
                    let categoryDict: [String: Any] = [
                        "title": category.title,
                        "imageLink": imageURL.absoluteString,
                        "createdDate": category.createdDate,
                        "linkedWordsId": category.linkedWordsId
                    ]
                    continuation.resume(returning: categoryDict)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func addDocumentToFireBase(dict: [String: Any]) async throws {
         return try await withCheckedThrowingContinuation { continuation in
             self.dataBase.collection("categories").addDocument(data: dict) { error in
                 if let error = error {
                     continuation.resume(throwing: error)
                 } else {
                     continuation.resume(returning: ())
                 }
             }
         }
     }

    func uploadCategoryImage(with imageLink: String?, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageLink = imageLink,
              let imageUrl = URL(string: imageLink)
        else {
            return
        }

        imageManager.loadImage(from: imageUrl) { result in
            switch result {
            case .success(let imageData):
                let imageRef = Storage.storage().reference().child("categories/\(UUID().uuidString)")

                let metadata = StorageMetadata()
                metadata.contentType = "image/png"

                imageRef.putData(imageData, metadata: metadata) { [weak self] _, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    imageRef.downloadURL { url, error in
                        if let url {
                            completion(.success(url))
                        } else if let error = error {
                            completion(.failure(error))
                        }
                    }
                    self?.downloadURL(from: imageRef, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
                return
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
