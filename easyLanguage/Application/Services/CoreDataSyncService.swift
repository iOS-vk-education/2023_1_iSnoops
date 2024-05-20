//
//  CoreDataSyncService.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.05.2024.
//

import Foundation
import CoreData
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


protocol ICoreDataSyncService {
    func syncAllDataToFirebase() async 
}
/// из coreData данные в бек
class CoreDataSyncService {
    static let shared: ICoreDataSyncService = CoreDataSyncService()
    
    private let coreDataService = CoreDataService()
    private let dataBase = Firestore.firestore()

    private init() {}

    private enum Constants {
        static let imageLink = "imageLink"
    }

    // swiftlint:disable:next line_length
    private let defaultImageLink = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2F1E1922CE-61D4-46BE-B2C7-4E12B316CCFA?alt=media&token=80174f66-ee40-4f34-9a35-8d7ed4fbd571"
}

extension CoreDataSyncService: ICoreDataSyncService {
    func syncAllDataToFirebase() async {
        guard let userId = getCurrentUserId() else {
            return
        }

        let context = coreDataService.persistentContainer.viewContext

        let topFiveWordsCD = fetchTopFive()
        for word in topFiveWordsCD {
            let apiWord = TopFiveWordsApiModel(translate: word.translate ?? [: ],
                                               userId: word.userId ?? "",
                                               id: word.id ?? "",
                                               date: word.date ?? Date.now)
                try? await createNewTopFiveWord(with: apiWord)
        }

        let categoriesCD = fetchCategories()
        for word in categoriesCD {
            let apiWord = CategoryApiModel(title: word.title ?? "",
                                           imageLink: ,
                                           createdDate: word.createdDate ?? Date.now,
                                           linkedWordsId: word.linkedWordsId ?? "",
                                           isDefault: word.isDefault)
                try? await createNewTopFiveWord(with: apiWord)
        }


    }

    private func fetchWords() {
        var words: [WordCDModel] = []
        let moc = coreDataService.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<WordCDModel>(entityName: "WordCDModel")
        guard let coreModel = try? moc.fetch(fetchRequest) else {
            return
        }
        for item in coreModel {
            words.append(item)
        }
    }

    private func fetchCategories() -> [CategoryCDModel] {
        var categories: [CategoryCDModel] = []
        let moc = coreDataService.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CategoryCDModel>(entityName: "CategoryCDModel")
        guard let coreModel = try? moc.fetch(fetchRequest) else {
            return []
        }
        for item in coreModel {
            categories.append(item)
        }
        return categories
    }

    private func fetchTopFive() -> [TopFiveWordsCDModel] {
        var words: [TopFiveWordsCDModel] = []
        let moc = coreDataService.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TopFiveWordsCDModel>(entityName: "TopFiveWordsCDModel")
        guard let coreModel = try? moc.fetch(fetchRequest) else {
            return []
        }
        for item in coreModel {
            words.append(item)
        }
        return words
    }

    private func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }

    // MARK: Top5

    public func createNewTopFiveWord(with word: TopFiveWordsApiModel) async throws {
        guard let userId = getCurrentUserId() else {
            throw AuthErrors.userNotAuthenticated
        }
            let uploadWord = try await makeTopFiveWordForRequest(with: word)
            try await addDocumentTopFiveToFireBase(dict: uploadWord)
    }

    private func makeTopFiveWordForRequest(with word: TopFiveWordsApiModel) async throws -> [String: Any] {
        guard let userId = getCurrentUserId() else {
            throw AuthErrors.userNotAuthenticated
        }
        let topFiveWord: [String: Any] = [
            "translate": word.translate,
            "userId": word.userId,
            "id": word.id,
            "date": Date.now
        ]
        return topFiveWord
    }

    private func deleteWord(with id: String) async throws {
        do {
            try await dataBase.collection("topFiveWords").document(id).delete()
        } catch {
            throw error
        }
    }

    private func addDocumentTopFiveToFireBase(dict: [String: Any]) async throws {
        do {
            try await dataBase.collection("topFiveWords").addDocument(data: dict)
        } catch {
            throw error
        }
    }
    // MARK: Category
    private func postCategory(with category: CategoryCDModel, image: UIImage?) async throws -> [String: Any] {
        guard let userId = getCurrentUserId() else {
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
