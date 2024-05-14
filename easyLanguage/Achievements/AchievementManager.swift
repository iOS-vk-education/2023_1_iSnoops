//
//  AchievementManager.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 14.05.2024.
//

import Foundation

struct AchievementModel {
    var isAchievementDone: Bool
    var count: Int
}

class AchievementManager {

    private var categories: [CategoryModel] = []
    private var answers: [AchievementModel] = []

    init(categories: [CategoryModel]) {
        self.categories = categories
        setAnswers()
    }

    private func setAnswers() {
        isAddedSomeCategories(requiredCategories: 1)
        isAddedSomeCategories(requiredCategories: 3)
        isLearnedSomeWords(requiredWords: 10)
        isLearnedSomeWords(requiredWords: 100)
        isLearnedSomeWords(requiredWords: 500)
        isSomeWordsInCategory(requiredWords: 50)
        isSomeCategoriesLearned(requiredCategories: 1)
        isSomeCategoriesLearned(requiredCategories: 3)
    }

    public func getAnswers() -> [AchievementModel] { answers }
}

private extension AchievementManager {
    func isLearnedSomeWords(requiredWords: Int) {
        var counter = 0
        categories.forEach {
            counter += $0.studiedWordsCount
        }
        answers.append(AchievementModel(isAchievementDone: counter >= requiredWords, count: counter))
    }

    func isAddedSomeCategories(requiredCategories: Int) {
        answers.append(AchievementModel(isAchievementDone: categories.count >= requiredCategories, count: categories.count))
    }

    func isSomeWordsInCategory(requiredWords: Int) {
        var counter = 0
        categories.forEach {
            counter = max($0.totalWordsCount, counter)
        }
        answers.append(AchievementModel(isAchievementDone: counter >= requiredWords, count: counter))
    }

    func isSomeCategoriesLearned(requiredCategories: Int) {
        var counter = 0
        categories.forEach {
            counter += ($0.studiedWordsCount == $0.totalWordsCount && $0.totalWordsCount > 0) ? 1 : 0
        }
        answers.append(AchievementModel(isAchievementDone: counter >= requiredCategories, count: counter))
    }
}
