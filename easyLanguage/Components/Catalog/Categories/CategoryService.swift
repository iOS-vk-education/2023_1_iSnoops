//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol CatalogNetworkManagerProtocol {
    func loadCategories() async throws -> [CategoryApiModel]
    func loadProgressView() async throws -> (Int, Int)
    func deleteCategory(with id: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class CategoryService: CatalogNetworkManagerProtocol {

    static let shared: CatalogNetworkManagerProtocol = CategoryService()
    private init() {}

    private let dataBase = Firestore.firestore()

    func loadCategories() async throws -> [CategoryApiModel] {
        guard let uid = checkAuthentication() else {
            print("пользователь не авторизован")
            throw AuthErrors.userNotAuthenticated
        }

        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection("categories")
                .whereField("profileId", isEqualTo: uid)
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

    func loadProgressView() async throws -> (Int, Int) {

        let categories = try await loadCategories()

        var totalWords = 0
        var learnedWords = 0

        for category in categories {
            let categoryId = category.linkedWordsId

            do {
                let words = try await loadWordsForCategory(with: categoryId)
                totalWords += words.total
                learnedWords += words.studied
            } catch {
                throw error
            }
        }

        return (totalWords, learnedWords)
    }

    func deleteCategory(with id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        dataBase.collection("categories").whereField("linkedWordsId", isEqualTo: id).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents, !documents.isEmpty else {
                completion(.failure(NetworkError.unexpected))
                return
            }

            for document in documents {
                document.reference.delete { error in
                    if let error = error {
                        completion(.success(false))
                    } else {
                        completion(.success(true))
                    }
                }
            }
        }
    }

    private func loadWordsForCategory(with categoryId: String) async throws -> (total: Int, studied: Int) {
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

    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }
}
