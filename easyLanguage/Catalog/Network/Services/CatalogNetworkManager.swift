//
//  CatalogNetworkManager.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

protocol CatalogNetworkManagerProtocol {
    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void)
    func postCategory(with newCategory: CategoryApiModel, completion: @escaping (Result<Void, Error>) -> Void)
    func getCategoryModelLastId(completion: @escaping (Result<Int, Error>) -> Void)
}

final class CatalogNetworkManager: CatalogNetworkManagerProtocol {

    static let shared = CatalogNetworkManager()
    private init() {}

    func getCategoryModelLastId(completion: @escaping (Result<Int, Error>) -> Void) {
        completion(.success(MockData.categoryModelLastId))
    }

    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        completion(.success(MockData.topFiveWords))
    }

    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void) {
        completion(.success(MockData.categoryModel))
    }

    func postCategory(with newCategory: CategoryApiModel, completion: @escaping (Result<Void, Error>) -> Void) {
        MockData.categoryModel.append(newCategory)
        completion(.success(()))
    }
}
