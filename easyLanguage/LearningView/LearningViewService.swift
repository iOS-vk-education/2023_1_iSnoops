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

protocol LearningViewServiceProtocol {
    func createNewTopFiveWord(with word: WordUIModel) async throws
    func loadWords() async throws -> [WordApiModel]
    func loadWordsInCategory(with categoryId: String) async throws -> [WordApiModel]
    func updateWord(with word: WordUIModel) async throws
}

final class LearningViewService: LearningViewServiceProtocol {

    private init() {}
    static let shared: LearningViewServiceProtocol = LearningViewService()

    private let dataBase = Firestore.firestore()

    // MARK: Public methods
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

    func loadWordsInCategory(with categoryId: String) async throws -> [WordApiModel] {
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

    public func createNewTopFiveWord(with word: WordUIModel) async throws {
        guard let userId = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }
        let check = try await checkIndividualIdForPostAsync(id: word.id, userId: userId)
        if check {
            let uploadWord = try await makeTopFiveWordForRequest(with: word)
            try await addDocumentTopFiveToFireBase(dict: uploadWord)
            try await checkCountOfWords()
        }
    }

    public func updateWord(with word: WordUIModel) async throws {
        guard let userId = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }
        try await updateWord(id: word.id,
                             isLearned: word.isLearned,
                             swipesCounter: word.swipesCounter)
    }

    // MARK: Private methods
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

    private func updateWord(id: String, isLearned: Bool, swipesCounter: Int) async throws {
        try await dataBase.collection("words").document(id).setData(["isLearned": isLearned,
                                                                     "swipesCounter": swipesCounter], merge: true)
    }

    private func checkIndividualIdForPostAsync(id: String,
                                               userId: String?) async throws -> Bool {
        var result: Bool
        let document = try await dataBase.collection("topFiveWords")
            .whereField("id", isEqualTo: id)
            .whereField("userId", isEqualTo: userId ?? "").getDocuments()
        result = document.isEmpty ? true : false
        return result
    }

    private func makeTopFiveWordForRequest(with word: WordUIModel) async throws -> [String: Any] {
        guard let userId = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }
        let topFiveWord: [String: Any] = [
            "translate": word.translations,
            "userId": userId,
            "id": word.id,
            "date": Date.now
        ]
        return topFiveWord
    }

    private func addDocumentTopFiveToFireBase(dict: [String: Any]) async throws {
        do {
            try await dataBase.collection("topFiveWords").addDocument(data: dict)
        } catch {
            throw error
        }
    }

    private func checkCountOfWords() async throws {
        guard let uid = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }
        do {
            let querySnapshot = try await dataBase.collection("topFiveWords")
                .whereField("userId", isEqualTo: uid).getDocuments()
            let documents = querySnapshot.documents
            if documents.count >= 6 {
                let topFiveWords: [TopFiveWordsApiModel] = getTopFiveWordsCollection(documents: documents)
                try await sortAndDeleteLastAddedWord(with: topFiveWords)
            }
        } catch {
            throw error
        }
    }
    private func getTopFiveWordsCollection(documents: [QueryDocumentSnapshot]) -> [TopFiveWordsApiModel] {
        let topFiveWords: [TopFiveWordsApiModel] = documents.compactMap { document in
            do {
                let word = try document.data(as: TopFiveWordsApiModel.self)
                return word
            } catch {
                return nil
            }
        }
        return topFiveWords
    }

    private func sortAndDeleteLastAddedWord(with model: [TopFiveWordsApiModel]) async throws {
        var sortedModel = model.sorted {
            $0.date > $1.date
        }
        let lastDocument = try await dataBase.collection("topFiveWords")
            .whereField("id", isEqualTo: sortedModel.last?.id ?? "").getDocuments().documents
        do {
            try await deleteWord(with: lastDocument.first?.documentID ?? "")
        } catch {
            throw error
        }
    }

    private func deleteWord(with id: String) async throws {
        do {
            try await dataBase.collection("topFiveWords").document(id).delete()
        } catch {
            throw error
        }
    }
}
