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
                    WordModel(wordId: word.wordId,
                              linkedWordsId: word.linkedWordsId,
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

    private func loadWordModelLastId(completion: @escaping (Result<Int, Error>) -> Void) {
        categoryDetailNetworkManager.getWordLastId { result in
            completion(result)
        }
    }

    func createWord(with newWord: WordModel, completion: @escaping (Result<WordModel, Error>) -> Void) {
        loadWordModelLastId { [weak self] result in
            switch result {
            case .success(let lastWordId):
                let newLastWordId = lastWordId + 1
                let wordApiModel =  WordApiModel(wordId: newLastWordId,
                                                 linkedWordsId: newWord.linkedWordsId,
                                                 words: newWord.words,
                                                 isLearned: newWord.isLearned,
                                                 createdDate: newWord.createdDate)
                self?.categoryDetailNetworkManager.postWord(with: wordApiModel) { result in
                    switch result {
                    case .success:
                        print("Новое слово успешно добавлено!")
                        completion(.success(WordModel(wordId: newLastWordId,
                                                      linkedWordsId: newWord.linkedWordsId,
                                                      words: newWord.words,
                                                      isLearned: newWord.isLearned,
                                                      createdDate: newWord.createdDate)))
                    case .failure(let error):
                        print("Ошибка при добавлении нового слова: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Ошибка при загрузке последнего ID слова: \(error.localizedDescription)")
            }
        }
    }

    func reloadLike(with wordId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        categoryDetailNetworkManager.putIsLearned(with: wordId) { result in
            switch result {
            case .success(let didLoadisLearned):
                completion(.success(didLoadisLearned))
            case .failure(let error):
                print("Ошибка изменения состояния лайка: \(error.localizedDescription)")
            }
        }
    }
}
