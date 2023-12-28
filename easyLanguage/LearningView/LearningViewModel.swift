//
//  LearningViewModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 28.12.2023.
//

import Foundation

final class LearningViewModel {
    private let learningViewService = LearningViewService.shared
    private var wordsUIModel = [WordUIModel]()

    func loadWords(completion: @escaping (Result<[WordUIModel], Error>) -> Void) {
        Task {
            do {
                let wordsAPIModel = try await self.learningViewService.loadWords()

                for word in wordsAPIModel {
                    let wordUIModel = WordUIModel(categoryId: word.categoryId,
                                                  translations: word.translations,
                                                  isLearned: word.isLearned,
                                                  id: word.id)
                    wordsUIModel.append(wordUIModel)
                }
                await MainActor.run {
                    completion(.success(self.wordsUIModel))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
