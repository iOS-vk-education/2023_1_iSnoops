//
//  CategoryDetailModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

final class CategoryDetailModel {
    private let categoryDetailNetworkManager = CategoryDetailNetworkManager.shared

    func loadWords(with linkedWordsId: String, completion: @escaping (Result<[WordModel], Error>) -> Void) {
        categoryDetailNetworkManager.getWords(with: linkedWordsId) { result in
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

    private func loadWordModelLastId(with categoryId: Int, completion: @escaping (Result<Int, Error>) -> Void) {
        categoryDetailNetworkManager.getWordLastId(with: categoryId) { result in
            completion(result)
        }
    }

    func createWord(with newWord: WordModel, categoryId: Int) {
        loadWordModelLastId(with: categoryId) { result in
            switch result {
            case .success(let lastWordId): //FIXME: weak self
                let newLastWordId = lastWordId + 1
                let wordApiModel =  WordApiModel(wordId: newLastWordId,
                                                 linkedWordsId: newWord.linkedWordsId,
                                                 words: newWord.words,
                                                 isLearned: newWord.isLearned,
                                                 createdDate: newWord.createdDate)
                self.categoryDetailNetworkManager.postWord(with: wordApiModel) { result in
                    switch result {
                    case .success:
                        print("Новое слово успешно добавлено!")
                    case .failure(let error):
                        print("Ошибка при добавлении нового слова: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Ошибка при загрузке последнего ID слова: \(error.localizedDescription)")
            }
        }
    }
}
