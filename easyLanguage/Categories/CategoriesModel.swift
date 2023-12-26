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
    
    func loadCategory() async {
        do {
            async let loadCategory = try catalogService.loadCategories()
             let categoryAPIModel =  try await loadCategory

             async let loadWords = try wordsService.loadWordsCounts(with: categoryAPIModel[0].linkedWordsId)
             let wordAPIModel =  try await loadWords
             
//             let categoryModel = CategoryApiModel(title: <#T##String#>, imageLink: <#T##String?#>, createdDate: <#T##Date#>, linkedWordsId: <#T##String#>)
//             let wordModel = .init(wordAPIModel)
             
         } catch let error {
             return await MainActor.run { //  чтобы ui обновлять
                 (categoryModel, wordModel) // или что вам тут нужно для ui (по mvc)
             }
         }
     }
    }

//    private func loadWordsCounts(with linkedWordsId: String,
//                                 completion: @escaping (Result<(total: Int, studied: Int), Error>) -> Void) {
//        wordsNetworkManager.getWordsCounts(with: linkedWordsId) { result in
//            switch result {
//            case .success(let counts):
//                completion(.success(counts))
//            case .failure(let error):
//                print(error.localizedDescription)
//                completion(.success((0, 0)))
//            }
//        }
//    }
//
//    func loadCategory(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
//        catalogNetworkManager.getCategories { [weak self] result in
//            switch result {
//            case .success(let categories):
//                var categoryModels: [CategoryModel] = []
//                let group = DispatchGroup()
//
//                for category in categories {
//                    group.enter()
//                    self?.loadWordsCounts(with: category.linkedWordsId) { result in
//                        switch result {
//                        case .success(let counts):
//                            let categoryModel = CategoryModel(
//                                title: category.title,
//                                imageLink: category.imageLink,
//                                studiedWordsCount: counts.studied,
//                                totalWordsCount: counts.total,
//                                createdDate: category.createdDate,
//                                linkedWordsId: category.linkedWordsId
//                            )
//                            categoryModels.append(categoryModel)
//                            group.leave()
//                        case .failure(let error):
//                            print(error.localizedDescription)
//                            group.leave()
//                        }
//                    }
//                }
//
//                group.notify(queue: .main) {
//                    completion(.success(categoryModels))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}
