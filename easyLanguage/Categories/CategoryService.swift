//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

protocol CategoryServiceProtocol {
    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void)
}

final class CategoryService: CategoryServiceProtocol {

    static let shared: CategoryServiceProtocol = CategoryService()
    private init() {}

    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void) {
        completion(.success(MockData.categoryModel))
    }
}
