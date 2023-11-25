//
//  CategoryDetailNetworkManager.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

protocol CategoryDetailNetworkManagerProtocol {
    func getWords(with linkedWordsId: String, completion: @escaping (Result<[WordApiModel], Error>) -> Void)
}

final class CategoryDetailNetworkManager: CategoryDetailNetworkManagerProtocol {

    static let shared = CategoryDetailNetworkManager()
    private init() {}

    func getWords(with linkedWordsId: String, completion: @escaping (Result<[WordApiModel], Error>) -> Void) {
        let filteredWords = MockData.wordModel.filter {
            $0.linkedWordsId == linkedWordsId
        }
        completion(.success(filteredWords))
    }
}
