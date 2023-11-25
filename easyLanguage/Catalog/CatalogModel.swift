//
//  CatalogModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

final class CatalogModel {
    private let catalogNetworkManager = CatalogNetworkManager.shared
    private let defaultImageLink = "https://climate.onep.go.th/wp-content/uploads/2020/01/default-image.jpg"

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
        catalogNetworkManager.getCategories { result in
            switch result {
            case .success(let categories):
                let categoryModels = categories.map { category in
                    CategoryModel(
                        title: category.title,
                        imageLink: category.imageLink,
                        studiedWordsCount: category.studiedWordsCount,
                        totalWordsCount: category.totalWordsCount,
                        createdDate: category.createdDate,
                        linkedWordsId: category.linkedWordsId
                    )
                }
                completion(.success(categoryModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func loadCategoryModelLastId(completion: @escaping (Result<Int, Error>) -> Void) {
        catalogNetworkManager.getCategoryModelLastId { result in
            completion(result)
        }
    }

    func createCategory(with newCategory: CategoryModel) {
        loadCategoryModelLastId { result in
            switch result {
            case .success(let lastCategoryId):
                let newCategoryId = lastCategoryId + 1
                let categoryApiModel = CategoryApiModel(
                    categoryId: newCategoryId,
                    title: newCategory.title,
                    imageLink: self.defaultImageLink, //FIXME: weak self
                    studiedWordsCount: newCategory.studiedWordsCount,
                    totalWordsCount: newCategory.totalWordsCount,
                    createdDate: Date(),
                    linkedWordsId: newCategory.linkedWordsId
                )
                //FIXME: weak self
                self.catalogNetworkManager.postCategory(with: categoryApiModel) { result in
                    switch result {
                    case .success:
                        print("Новая категория успешно добавлена!")
                    case .failure(let error):
                        print("Ошибка при добавлении новой категории: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Ошибка при загрузке последнего ID категории: \(error.localizedDescription)")
            }
        }
    }
}
