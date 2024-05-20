//
//  BackendSyncService.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import CoreData

/// с бека данные в coreData
protocol IBackendSyncService {
    func syncAllDataToCoreData() async
}

final class BackendSyncService {
    static let shared: IBackendSyncService = BackendSyncService()
    private init() {}

    private let coreData = CoreDataService()
    private let dataBase = Firestore.firestore()
}

// MARK: - IBackendSyncService

extension BackendSyncService: IBackendSyncService {
    func syncAllDataToCoreData() async {
        guard let userId = getCurrentUserId() else {
            print(#function, "ошибка получения UserId")
            return
        }

        do {
            let categories: [CategoryApiModel] = try await fetchData(collection: "categories", userId: userId)
            await saveCategoriesToCoreData(categories: categories)

            let words: [WordApiModel] = try await fetchData(collection: "words", userId: userId)
            saveWordsToCoreData(words: words)

            let topFiveWords: [TopFiveWordsApiModel] = try await fetchData(collection: "topFiveWords", userId: userId)
//            saveTopFiveWordsToCoreData(topFiveWords)
            print("categories", categories)
            print("words", words)
            print("topFiveWords", topFiveWords)
        } catch {
            print("Failed to sync data: \(error)")
        }
    }
}

// MARK: - Fetch

private extension BackendSyncService {
    func fetchData<T: Decodable>(collection: String, userId: String) async throws -> [T] {
        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection(collection)
                .whereField("profileId", isEqualTo: userId)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print(error)
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let documents = querySnapshot?.documents else {
                        continuation.resume(throwing: NetworkError.unexpected)
                        return
                    }

                    let items: [T] = documents.compactMap { document in
                        do {
                            let item = try document.data(as: T.self)
                            return item
                        } catch {
                            continuation.resume(throwing: error)
                            return nil
                        }
                    }

                    continuation.resume(returning: items)
                }
        }
    }
}

// MARK: - Save to coreData

private extension BackendSyncService {
    func saveCategoriesToCoreData(categories: [CategoryApiModel]) async {
        let moc = coreData.persistentContainer.viewContext

        do {
            for category in categories {
                let newCategory = CategoryCDModel(context: moc)
                let (total, learned) = try await loadWordsForCategory(with: category.linkedWordsId)
                newCategory.createdDate = category.createdDate
                newCategory.imageData = stringToData(with: category.imageLink)
                newCategory.linkedWordsId = category.linkedWordsId
                newCategory.studiedWordsCount = Int64(learned)
                newCategory.title = category.title
                newCategory.totalWordsCount = Int64(total)
                newCategory.isDefault = category.isDefault
            }
            try moc.save()
        } catch {
            print(#function, "не удалось загрузить категории (синк с беком): \(error)")
        }
    }

    func saveWordsToCoreData(words: [WordApiModel]) {
        let moc = coreData.persistentContainer.viewContext

        do {
            for word in words {
                let newWord = WordCDModel(context: moc)
                newWord.categoryId = word.categoryId
                newWord.translations = word.translations
                newWord.isLearned = word.isLearned
                newWord.swipesCounter = Int64(word.swipesCounter)
                newWord.id = word.id
            }
            try moc.save()
        } catch {
           print(#function, "не удалось загрузить слова (синк с беком): \(error)")
       }
    }
}

// MARK: - Helpers

private extension BackendSyncService {
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }

    func stringToData(with strLink: String?) -> Data? {
        var data: Data? = Data()
        guard let strLink = strLink,
              let url = URL(string: strLink) else {
            data = imageToData()
            return data
        }

        ImageManager.shared.loadImage(from: url) { [weak self] result in
            switch result {
            case .success(let imgData):
                data = imgData
            case .failure(let error):
                data = self?.imageToData()
            }
        }
        return data
    }

    func imageToData(image: UIImage = UIImage.defaultImage) -> Data? {
       image.jpegData(compressionQuality: 0.2)
    }

    func loadWordsForCategory(with categoryId: String) async throws -> (total: Int, studied: Int) {
        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection("words").whereField("categoryId",
                                        isEqualTo: categoryId).getDocuments { querySnapshot, error in
                if let error = error {
                    print(error)
                    continuation.resume(throwing: error)
                }

                guard let documents = querySnapshot?.documents else {
                    continuation.resume(throwing: NetworkError.unexpected)
                    return
                }

                let totalWordsCount = documents.count
                let studiedWordsCount = documents.filter { document in
                    (try? document.data(as: WordApiModel.self))?.isLearned == true
                }.count

                let result = (total: totalWordsCount, studied: studiedWordsCount)
                continuation.resume(returning: result)
            }
        }
    }
}

private extension UIImage {
    static let defaultImage = UIImage(systemName: "questionmark")!
}
