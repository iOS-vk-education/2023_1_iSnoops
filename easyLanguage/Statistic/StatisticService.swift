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

struct StatisticModel {
    let categories: [CategoryApiModel]
    let categoriesAndWords: [String: Int]
    let allWords: [WordApiModel]
    let learned: [WordApiModel]
}

struct StatisticService {
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
                .whereField("categoryId", isEqualTo: categoryId).getDocuments { querySnapshot, error in
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

    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }

}
