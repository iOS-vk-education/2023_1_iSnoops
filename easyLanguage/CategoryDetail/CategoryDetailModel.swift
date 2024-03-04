//
//  CategoryDetailModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import Foundation

final class CategoryDetailModel {

    private let categoryService = CategoryDetailService.shared

    func loadWords(with linkedWordsId: String, completion: @escaping (Result<[WordUIModel], Error>) -> Void) {
        categoryService.loadWords(with: linkedWordsId) { result in
            switch result {
            case .success(let wordsApiModel):
                let wordsModel = wordsApiModel.map { word in
                    WordUIModel(categoryId: word.categoryId,
                                translations: word.translations,
                                isLearned: word.isLearned,
                                id: word.id)
                }
                completion(.success(wordsModel))
            case .failure(let error):
                print("[DEBUG]: \(#function), \(error.localizedDescription)")
            }
        }
    }

    func reloadIsLearned(with id: String, isLearned: Bool) {
        categoryService.reloadIsLearned(with: id, isLearned: isLearned)
    }

    func deleteWord(with id: String, comletion: @escaping (Result<Void, Error>) -> Void) {
        categoryService.deleteWord(with: id) { result in
            comletion(result)
        }
    }
}
