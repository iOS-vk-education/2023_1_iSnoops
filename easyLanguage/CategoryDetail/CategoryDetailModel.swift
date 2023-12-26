//
//  CategoryDetailModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import Foundation

final class CategoryDetailModel {

    private let categoryDetailNetworkManager = CategoryDetailNetworkManager.shared

    func loadWords(with linkedWordsId: String, completion: @escaping (Result<[WordUIModel], Error>) -> Void) {
        categoryDetailNetworkManager.getWords(with: linkedWordsId) { result in
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
}
