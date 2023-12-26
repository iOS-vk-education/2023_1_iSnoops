//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

protocol CategoryServiceProtocol {
    func loadCategories() async throws -> [CategoryApiModel]
}

final class CategoryService: CategoryServiceProtocol {

    static let shared: CategoryServiceProtocol = CategoryService()

    func loadCategories() async throws -> [CategoryApiModel] {
        return try await MockData.categoryModel
    }
}
