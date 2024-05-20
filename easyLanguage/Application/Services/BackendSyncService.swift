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

    static let coreData = CoreDataService()
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
//            saveCategoriesToCoreData(categories)

            let words: [WordApiModel] = try await fetchData(collection: "words", userId: userId)
//            saveWordsToCoreData(words)

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

// MARK: - Fetchers

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

// MARK: - Helpers

private extension BackendSyncService {
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
