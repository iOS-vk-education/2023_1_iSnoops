//
//  WordsService.swift
//  easyLanguage
//
//  Created by Grigoriy on 09.12.2023.
//

import Foundation
import FirebaseFirestore

protocol WordsServiceProtocol {
//    func getWordsCounts(with categoryId: String,
//                        completion: @escaping (Result<(total: Int, studied: Int), Error>) -> Void)
    func loadWordsCounts(with categoryId: String) async throws -> (total: Int, studied: Int)
}

final class WordsService: WordsServiceProtocol {

    static let shared: WordsServiceProtocol = WordsService()
    private let dataBase = Firestore.firestore()
//
//    func getWordsCounts(with categoryId: String,
//                        completion: @escaping (Result<(total: Int, studied: Int), Error>) -> Void) {
//        let totalWordsCount = MockData.wordModel.filter { $0.categoryId == categoryId }.count
//        let studiedWordsCount = MockData.wordModel.filter { $0.categoryId == categoryId && $0.isLearned }.count
//
//        let result = (total: totalWordsCount, studied: studiedWordsCount)
//        completion(.success(result))
//    }
//    
    func loadWordsCounts(with categoryId: String) async throws -> (total: Int, studied: Int) {
        return try await withCheckedThrowingContinuation { continuation in //Создание асинхронности из функции, если ошибки возможны, продолжен (resume) ТОЛЬКО один раз
            dataBase.collection("words").whereField("categoryId", isEqualTo: categoryId).getDocuments { querySnapshot, error in
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
