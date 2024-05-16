//
//  CategoriesModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//
import Foundation

final class CategoriesModel {
    private let categoryService = CategoryService.shared
    private let wordsService = WordsService.shared

    private var categoriesModel = [CategoryModel]()
    // swiftlint:disable line_length
    private let defaultImageLink = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2F1E1922CE-61D4-46BE-B2C7-4E12B316CCFA?alt=media&token=80174f66-ee40-4f34-9a35-8d7ed4fbd571"
    // swiftlint:enable line_length

    func loadCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        Task {
            do {
                let categoryAPIModel = try await self.categoryService.loadCategories()

                for (index, category) in categoryAPIModel.enumerated() {
                    let counts = try await loadWordsCounts(with: category.linkedWordsId)
                    var imageLink = category.imageLink

                    imageLink = imageLink ?? defaultImageLink

                    let categoryModel = CategoryModel(
                        title: category.title,
                        imageLink: imageLink,
                        studiedWordsCount: counts.1,
                        totalWordsCount: counts.0,
                        createdDate: category.createdDate,
                        linkedWordsId: category.linkedWordsId,
                        index: index,
                        isDefault: false
                    )
                    categoriesModel.append(categoryModel)
                }
                await MainActor.run {
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
