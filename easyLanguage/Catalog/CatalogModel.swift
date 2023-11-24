//
//  CatalogModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

final class CatalogModel {
    private let catalogNetworkManager = CatalogNetworkManager.shared

    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsModel], Error>) -> Void) {
        catalogNetworkManager.getTopFiveWords { result in
            switch result {
            case .success(let topFiveData):
                let topFiveWords = topFiveData.map { word in
                    TopFiveWordsModel(
                        topFiveWordsId: word.topFiveWordsId,
                        title: word.title,
                        level: word.level
                    )
                }
                completion(.success(topFiveWords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadCategory(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        let defaultImageLink = "https://climate.onep.go.th/wp-content/uploads/2020/01/default-image.jpg"
        catalogNetworkManager.getCategories { result in
            switch result {
            case .success(let categories):
                let categoryModels = categories.map { category in
                    CategoryModel(
                        categoryId: category.categoryId,
                        title: category.title,
                        imageLink: category.imageLink ?? defaultImageLink,
                        studiedWordsCount: category.studiedWordsCount,
                        totalWordsCount: category.totalWordsCount,
                        createdDate: category.createdDate
                    )
                }
                completion(.success(categoryModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createCategory(with newCategory: CategoryModel) {
        let defaultImageLink = "https://climate.onep.go.th/wp-content/uploads/2020/01/default-image.jpg"
        let categoryApiModel = CategoryApiModel(categoryId: newCategory.categoryId,
                                                title: newCategory.title,
                                                imageLink: defaultImageLink,
                                                studiedWordsCount: newCategory.studiedWordsCount,
                                                totalWordsCount: newCategory.totalWordsCount,
                                                createdDate: Date(),
                                                words: nil)
        CatalogNetworkManager.shared.postCategory(with: categoryApiModel) { result in
            switch result {
            case .success:
                print("Новая категория успешно добавлена!")
            case .failure(let error):
                print("Ошибка при добавлении новой категории: \(error.localizedDescription)")
            }
        }
    }
}
