//
//  CategoriesModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//
import Foundation

final class CategoriesModel {
    private let catalogService = CategoryService.shared
    private let wordsService = WordsService.shared

    private func loadWordsCounts(with linkedWordsId: String) async throws -> (Int, Int) {
        try await wordsService.loadWordsCounts(with: linkedWordsId)
    }

    func loadCategory() async throws -> [CategoryModel] {
        var categoriesModel = [CategoryModel]()
        let categoryAPIModel = try await catalogService.loadCategories()

        for category in categoryAPIModel {
            let counts = try await loadWordsCounts(with: category.linkedWordsId)
            let categoryModel = CategoryModel(
                title: category.title,
                imageLink: category.imageLink,
                studiedWordsCount: counts.1,
                totalWordsCount: counts.0,
                createdDate: category.createdDate,
                linkedWordsId: category.linkedWordsId
            )
            categoriesModel.append(categoryModel)
        }
        return categoriesModel
    }
}
