//
//  CategoryDetailNetworkManager.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import Foundation

protocol CategoryDetailNetworkManagerProtocol {
    func getWords(with linkedWordsId: String, completion: @escaping (Result<[WordApiModel], Error>) -> Void)
    func addWord(with newWord: WordApiModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class CategoryDetailNetworkManager: CategoryDetailNetworkManagerProtocol {

    static let shared: CategoryDetailNetworkManagerProtocol = CategoryDetailNetworkManager()

    func getWords(with categoryId: String, completion: @escaping (Result<[WordApiModel], Error>) -> Void) {
        let filteredWords = MockData.wordModel.filter {
            $0.categoryId == categoryId
        }
        completion(.success(filteredWords))
    }

    func addWord(with newWord: WordApiModel, completion: @escaping (Result<Void, Error>) -> Void) {
        MockData.wordModel.append(newWord)
        completion(.success(()))
    }
}
