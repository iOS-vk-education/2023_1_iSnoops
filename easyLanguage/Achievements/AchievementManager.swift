//
//  AchievementManager.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 14.05.2024.
//

import Foundation

class AchievementManager {

    private var categories: [CategoryModel] = []
    private var answers: [AchievementModel] = []

    init(categories: [CategoryModel]) {
        self.categories = categories
        setAnswers()
    }

    private enum ComparisonCondition {
        case amountCategories
        case amountLearnedWords
        case amountWordsInCategory
        case amountCategoriesLearned
    }

    private func setAnswers() {
        addAnswer(requiredValue: 1, comparisonCondition: .amountCategories)
        addAnswer(requiredValue: 5, comparisonCondition: .amountCategories)
        addAnswer(requiredValue: 10, comparisonCondition: .amountLearnedWords)
        addAnswer(requiredValue: 100, comparisonCondition: .amountLearnedWords)
        addAnswer(requiredValue: 500, comparisonCondition: .amountLearnedWords)
        addAnswer(requiredValue: 50, comparisonCondition: .amountWordsInCategory)
        addAnswer(requiredValue: 1, comparisonCondition: .amountCategoriesLearned)
        addAnswer(requiredValue: 3, comparisonCondition: .amountCategoriesLearned)
    }

    private func addAnswer(requiredValue: Int, comparisonCondition: ComparisonCondition) {
        var counter = 0
        switch comparisonCondition {
        case .amountCategories:
            categories.forEach {
                print($0.isDefault, $0.title)
                counter += ($0.isDefault) ? 0 : 1
            }
        case .amountLearnedWords:
            categories.forEach {
                counter += $0.studiedWordsCount
            }
        case .amountWordsInCategory:
            categories.forEach {
                counter = max($0.totalWordsCount, counter)
            }
        case .amountCategoriesLearned:
            categories.forEach {
                counter += ($0.studiedWordsCount == $0.totalWordsCount && $0.totalWordsCount > 0) ? 1 : 0
            }
        }
        answers.append(AchievementModel(isAchievementDone: counter >= requiredValue, count: counter, required: requiredValue))
    }

    public func getAnswers() -> [AchievementModel] { answers }
}
