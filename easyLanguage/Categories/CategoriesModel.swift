//
//  CategoriesModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//

import Foundation

final class CategoriesModel {
    private let catalogNetworkManager = CatalogNetworkManager.shared //FIXME: - изменить сервис после мержа ветки с сервисами

    func loadCategory(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        catalogNetworkManager.getCategories { result in
            switch result {
            case .success(let categories):
                let categoryModels = categories.map { category in
                    CategoryModel(title: category.title,
                                  imageLink: category.imageLink,
                                  studiedWordsCount: 0, //FIXME: - нужен запрос
                                  totalWordsCount: 0, //FIXME: - нужен запрос
                                  createdDate: category.createdDate,
                                  linkedWordsId: category.linkedWordsId)
                }
                completion(.success(categoryModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
