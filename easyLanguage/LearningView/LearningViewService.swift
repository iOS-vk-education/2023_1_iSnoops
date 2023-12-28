//
//  LearningViewService.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

enum AuthErrors: Error {
    case userNotAuthenticated
}

protocol LearningViewServiceProtocol {
     func loadWords() async throws -> [WordApiModel]
}

final class LearningViewService: LearningViewServiceProtocol {

    static let shared: LearningViewServiceProtocol = LearningViewService()

    private let dataBase = Firestore.firestore()

    func loadWords() async throws -> [WordApiModel] {

        let categories = try await loadCategories()
        var words = [WordApiModel]()

        for category in categories {
            let categoryId = category.linkedWordsId

            do {
                let categoryWords = try await loadWordsInCategory(with: categoryId)
                words.append(contentsOf: categoryWords)
            } catch {
                throw error
            }
        }

        return words
    }

    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }

    private func loadCategories() async throws -> [CategoryApiModel] {
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

    private func loadWordsInCategory(with categoryId: String) async throws -> [WordApiModel] {
        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection("words")
                .whereField("categoryId", isEqualTo: categoryId)
                .whereField("isLearned", isEqualTo: false).getDocuments { querySnapshot, error in
                    if let error = error {
                        print(error)
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let documents = querySnapshot?.documents else {
                        continuation.resume(throwing: NetworkError.unexpected)
                        return
                    }

                    let categoryWords: [WordApiModel] = documents.compactMap { document in
                        do {
                            let word = try document.data(as: WordApiModel.self)
                            return word
                        } catch {
                            continuation.resume(throwing: error)
                            return nil
                        }
                    }

                    continuation.resume(returning: categoryWords)
                }
        }
    }
}
