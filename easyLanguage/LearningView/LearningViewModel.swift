//
//  LearningViewModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import CoreData

final class LearningViewModel {
    private let learningViewService = LearningViewService.shared
    private let coreDataService = CoreDataService()
    private var wordsUIModel = [WordUIModel]()

    func loadWords() async throws -> [WordUIModel] {
        let wordsAPIModel = try await learningViewService.loadWords()
        var wordsUIModel: [WordUIModel] = []
        for word in wordsAPIModel {
            let wordUIModel = WordUIModel(categoryId: word.categoryId,
                                          translations: word.translations,
                                          isLearned: word.isLearned,
                                          swipesCounter: word.swipesCounter,
                                          id: word.id)
            wordsUIModel.append(wordUIModel)
        }
        return wordsUIModel
    }

    func postWords(words: [WordUIModel]) async throws {
        for word in words {
            try await learningViewService.createNewTopFiveWord(with: word)
        }
    }

    func updateWords(words: [WordUIModel]) async throws {
        for word in words {
            try await learningViewService.updateWord(with: word)
        }
    }
    func updateWord(words: WordUIModel) async throws {
            try await learningViewService.updateWord(with: words)
    }
}
