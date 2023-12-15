//
//  CategoriesModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 13.12.2023.
//
import Foundation

final class CategoriesModel {
    private let catalogNetworkManager = CategoryService.shared
    private let wordsNetworkManager = WordsService.shared

    private func loadWordsCounts(with linkedWordsId: String,
                                 completion: @escaping (Result<(total: Int, studied: Int), Error>) -> Void) {
        wordsNetworkManager.getWordsCounts(with: linkedWordsId) { result in
            switch result {
            case .success(let counts):
                completion(.success(counts))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.success((0, 0)))
            }
        }
    }

    func loadCategory(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        catalogNetworkManager.getCategories { [weak self] result in
            switch result {
            case .success(let categories):
                var categoryModels: [CategoryModel] = []

                for category in categories {
                    self?.loadWordsCounts(with: category.linkedWordsId) { result in
                        switch result {
                        case .success(let counts):
                            let categoryModel = CategoryModel(
                                title: category.title,
                                imageLink: category.imageLink,
                                studiedWordsCount: counts.studied,
                                totalWordsCount: counts.total,
                                createdDate: category.createdDate,
                                linkedWordsId: category.linkedWordsId
                            )
                            categoryModels.append(categoryModel)
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                completion(.success(categoryModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
