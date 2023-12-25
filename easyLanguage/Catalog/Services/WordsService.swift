//
//  WordsService.swift
//  easyLanguage
//
//  Created by Grigoriy on 09.12.2023.
//

import Foundation

protocol WordsServiceProtocol {
    func getWordsCounts(with categoryId: String,
                        completion: @escaping (Result<(total: Int, studied: Int), Error>) -> Void)
}

final class WordsService: WordsServiceProtocol {

    static let shared: WordsServiceProtocol = WordsService()

    func getWordsCounts(with categoryId: String,
                        completion: @escaping (Result<(total: Int, studied: Int), Error>) -> Void) {
        let totalWordsCount = MockData.wordModel.filter { $0.categoryId == categoryId }.count
        let studiedWordsCount = MockData.wordModel.filter { $0.categoryId == categoryId && $0.isLearned }.count

        let result = (total: totalWordsCount, studied: studiedWordsCount)
        completion(.success(result))
    }
}
