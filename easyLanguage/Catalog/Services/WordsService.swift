//
//  WordsService.swift
//  easyLanguage
//
//  Created by Grigoriy on 09.12.2023.
//

import Foundation

protocol WordsNetworkManagerProtocol {
    func getTotalWordsCount(with linkedWordsId: String, completion: @escaping (Result<Int, Error>) -> Void)
    func getStudiedWordsCount(with linkedWordsId: String, completion: @escaping (Result<Int, Error>) -> Void)
}

final class WordsNetworkManager: WordsNetworkManagerProtocol {

    static let shared = WordsNetworkManager()
    private init() {}

    func getTotalWordsCount(with categoryId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let totalWordsCount = MockData.wordModel.filter {
            $0.categoryId == categoryId
        }.count
        completion(.success(totalWordsCount))
    }

    func getStudiedWordsCount(with categoryId: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let studiedWordsCount = MockData.wordModel.filter {
            $0.categoryId == categoryId && $0.isLearned == true
        }.count
        completion(.success(studiedWordsCount))
    }
}
