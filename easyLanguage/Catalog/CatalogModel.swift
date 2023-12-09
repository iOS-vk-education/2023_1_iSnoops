//
//  CatalogModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

final class CatalogModel {
    private let topFiveNetworkManager = TopFiveNetworkManager.shared
    private let catalogNetworkManager = CategoryNetworkManager.shared
    private let wordsNetworkManager = WordsNetworkManager.shared

    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsModel], Error>) -> Void) {
        topFiveNetworkManager.getTopFiveWords { result in
            switch result {
            case .success(let topFiveData):
                let topFiveWords = topFiveData.map { word in
                    TopFiveWordsModel(
                        translations: word.translations,
                        level: word.level
                    )
                }
                completion(.success(topFiveWords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func loadTotalWordsCount(with linkedWordsId: String, completion: @escaping (Int) -> Void) {
        wordsNetworkManager.getTotalWordsCount(with: linkedWordsId) { result in
            switch result {
            case .success(let loadTotalWordsCount):
                completion(loadTotalWordsCount)
            case .failure(let error):
                print(error.localizedDescription)
                completion(0)
            }
        }
     }

    private func loadStudiedWordsCount(with linkedWordsId: String, completion: @escaping (Int) -> Void) {
        wordsNetworkManager.getStudiedWordsCount(with: linkedWordsId) { result in
            switch result {
            case .success(let loadTotalWordsCount):
                completion(loadTotalWordsCount)
            case .failure(let error):
                print(error.localizedDescription)
                completion(0)
            }
        }
     }

    func loadCategory(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        let defaultImageLink = "https://climate.onep.go.th/wp-content/uploads/2020/01/default-image.jpg"
        catalogNetworkManager.getCategories { result in
            switch result {
            case .success(let categories):
                var totalCount = 0
                var studiedCount = 0
                //FIXME: добавить dispatchgroup который будет ждать результат выполнения
                let categoryModels = categories.map { [weak self] category in
                    self?.loadTotalWordsCount(with: category.linkedWordsId, completion: { totalWordsCount in
                        totalCount = totalWordsCount
                    })

                    self?.loadStudiedWordsCount(with: category.linkedWordsId, completion: { studiedWordsCount in
                        studiedCount = studiedWordsCount
                    })

                    return CategoryModel(title: category.title,
                                  imageLink: category.imageLink,
                                  studiedWordsCount: studiedCount,
                                  totalWordsCount: totalCount,
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
}
