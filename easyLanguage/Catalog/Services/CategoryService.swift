//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

protocol CatalogNetworkManagerProtocol {
    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
}

final class CatalogNetworkManager: CatalogNetworkManagerProtocol {

    static let shared = CatalogNetworkManager()
    private init() {}

    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        completion(.success(MockData.topFiveWords))
    }

    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void) {
        completion(.success(MockData.categoryModel))
    }
}
