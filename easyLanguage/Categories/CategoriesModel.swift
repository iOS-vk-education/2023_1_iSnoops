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

    private var categoriesModel = [CategoryModel]()

    func loadCategory(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        Task {
            do {
                let categoryAPIModel = try await catalogService.loadCategories()

                for (index, category) in categoryAPIModel.enumerated() {
                    let counts = try await loadWordsCounts(with: category.linkedWordsId)
                    let categoryModel = CategoryModel(
                        title: category.title,
                        imageLink: category.imageLink,
                        studiedWordsCount: counts.1,
                        totalWordsCount: counts.0,
                        createdDate: category.createdDate,
                        linkedWordsId: category.linkedWordsId,
                        index: index
                    )
                    categoriesModel.append(categoryModel)
                }
                DispatchQueue.main.async {
                    completion(.success(self.categoriesModel))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func loadWordsCounts(with linkedWordsId: String) async throws -> (Int, Int) {
        try await wordsService.loadWordsCounts(with: linkedWordsId)
    }
}
