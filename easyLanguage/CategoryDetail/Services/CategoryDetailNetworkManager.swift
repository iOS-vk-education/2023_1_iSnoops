//
//  CategoryDetailNetworkManager.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

protocol CategoryDetailNetworkManagerProtocol {
    func getWords(with linkedWordsId: String, completion: @escaping (Result<[WordApiModel], Error>) -> Void)
}

final class CategoryDetailNetworkManager: CategoryDetailNetworkManagerProtocol {

    static let shared = CategoryDetailNetworkManager()
    private init() {}

    func getWords(with linkedWordsId: String, completion: @escaping (Result<[WordApiModel], Error>) -> Void) {
        let filteredWords = MockData.wordModel.filter {
            $0.linkedWordsId == linkedWordsId
        }
        completion(.success(filteredWords))
    }

    func getWordLastId(completion: @escaping (Result<Int, Error>) -> Void) {
        completion(.success(MockData.wordModelLastId))
    }

    func postWord(with newWord: WordApiModel, completion: @escaping (Result<Void, Error>) -> Void) {
        MockData.wordModel.append(newWord)
        completion(.success(()))
    }

//    func putIsLearned(with wordId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
//        guard let index = MockData.wordModel.firstIndex(where: { $0.wordId == wordId }) else {
//            completion(.failure(NetworkError.idError))
//            return
//        }
//        print("CategoryDetailNetworkManager index", index)
//        let oldWord = MockData.wordModel[index]
//        MockData.wordModel.remove(at: index)
//        print(MockData.wordModel)
//        let newWord = WordApiModel(wordId: oldWord.wordId,
//                                   linkedWordsId: oldWord.linkedWordsId,
//                                   words: oldWord.words,
//                                   isLearned: !oldWord.isLearned,
//                                   createdDate: oldWord.createdDate)
//        MockData.wordModel.append(newWord)
//        print("CategoryDetailNetworkManager newWord", newWord)
//        completion(.success(newWord.isLearned))
//    }

    //FIXME: решить проблему при asyncAfter
    func putIsLearned(with wordId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let index = MockData.wordModel.firstIndex(where: { $0.wordId == wordId }) else {
            completion(.failure(NetworkError.idError))
            return
        }
        var updatedWord = MockData.wordModel[index]
        updatedWord.isLearned.toggle()
        MockData.wordModel[index] = updatedWord
        completion(.success(updatedWord.isLearned))
    }
}
