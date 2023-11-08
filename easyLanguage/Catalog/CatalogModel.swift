//
//  CatalogModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

final class CatalogModel {

    private let wordsNetworkManager = CatalogNetworkManager.shared

    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsModel], Error>) -> Void) {
        wordsNetworkManager.getTopFiveWords { result in
            switch result {
            case .success(let topFiveData):
                let topFiveWords = topFiveData.map { words in
                    TopFiveWordsModel(topFiveWordsId: words.topFiveWordsId,
                                      ruTitle: words.ruTitle,
                                      engTitle: words.engTitle,
                                      level: words.level)
                }
                completion(.success(topFiveWords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadCategory(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        let defaultImageLink = "https://climate.onep.go.th/wp-content/uploads/2020/01/default-image.jpg"
        wordsNetworkManager.getCategories { result in
            switch result {
            case .success(let category):
                let categories = category.map { category in
                    CategoryModel(
                        categoryId: category.categoryId,
                        ruTitle: category.ruTitle,
                        engTitle: category.engTitle,
                        imageLink: category.imageLink ?? defaultImageLink,
                        studiedWordsCount: category.studiedWordsCount,
                        totalWordsCount: category.totalWordsCount
                    )
                }
                completion(.success(categories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
