//
//  StatisticService.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 06.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct StatisticService {
    private enum FieldNames {
        static let categories = "categories"
        static let profileId = "profileId"
        static let words = "words"
        static let categoryId = "categoryId"
        static let isLearned = "isLearned"
    }

    private let dataBase = Firestore.firestore()

    public func loadWordsAndCategories() async throws -> StatisticModel {
        let categories = try await loadCategories()
        var categoryNameAndWordsCount = [String: Int]()
        var words = [WordApiModel]()
        var learnedWords = [WordApiModel]()
        for category in categories {
            let categoryId = category.linkedWordsId
            do {
                let categoryWords = try await loadWordsInCategory(with: categoryId)
                let learnedCategoryWords = try await loadLearnedWordsInCategory(with: categoryId)
                categoryNameAndWordsCount[category.title] = categoryWords.count
                words.append(contentsOf: categoryWords)
                learnedWords.append(contentsOf: learnedCategoryWords)
            } catch {
                throw error
            }
        }
        return StatisticModel(categories: categories,
                              categoriesAndWords: categoryNameAndWordsCount,
                              allWords: words,
                              learned: learnedWords)
    }

    private func loadCategories() async throws -> [CategoryApiModel] {
        guard let uid = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }

        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection(FieldNames.categories)
                .whereField(FieldNames.profileId, isEqualTo: uid)
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
            dataBase.collection(FieldNames.words)
                .whereField(FieldNames.categoryId, isEqualTo: categoryId).getDocuments { querySnapshot, error in
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

    private func loadLearnedWordsInCategory(with categoryId: String) async throws -> [WordApiModel] {
        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection(FieldNames.words)
                .whereField(FieldNames.categoryId, isEqualTo: categoryId)
                .whereField(FieldNames.isLearned, isEqualTo: false).getDocuments { querySnapshot, error in
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

    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }
}
