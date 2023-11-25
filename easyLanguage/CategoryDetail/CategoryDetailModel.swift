//
//  CategoryDetailModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

final class CategoryDetailModel {
    private let catalogNetworkManager = CategoryDetailNetworkManager.shared

    func loadWords(with linkedWordsId: String, completion: @escaping (Result<[WordModel], Error>) -> Void) {
        catalogNetworkManager.getWords(with: linkedWordsId) { result in
            switch result {
            case .success(let wordsApiModel):
                let wordsModel = wordsApiModel.map { word in
                    WordModel(linkedWordsId: word.linkedWordsId,
                              words: word.words,
                              isLearned: word.isLearned,
                              createdDate: word.createdDate)
                }
                completion(.success(wordsModel))
            case .failure(let error):
                print("[DEBUG]: \(#function), \(error.localizedDescription)")
            }
        }
    }
}
