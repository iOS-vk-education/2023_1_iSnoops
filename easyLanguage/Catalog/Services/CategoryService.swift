//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

protocol CategoryNetworkManagerProtocol {
    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void)
}

final class CategoryNetworkManager: CategoryNetworkManagerProtocol {

    static let shared = CategoryNetworkManager()
    private init() {}

    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void) {
        completion(.success(MockData.categoryModel))
    }
}
