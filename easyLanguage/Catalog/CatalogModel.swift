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
                    TopFiveWordsModel(translations: word.translations,
                                      level: word.level)
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
