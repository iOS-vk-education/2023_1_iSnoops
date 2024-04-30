//
//  WordUIModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

struct WordUIModel {
    let categoryId: String // Связующий идентификатор для связи с категорией
    let translations: [String: String]
    var isLearned: Bool
    var swipesCounter: Int
    let id: String // для лайка

    init(
        categoryId: String = "2222",
        translations: [String: String] = ["ru": "Кодирование", "en": "Coding"],
        isLearned: Bool = false,
        swipesCounter: Int = 0,
        id: String = "222"
    ) {
        self.categoryId = categoryId
        self.translations = translations
        self.isLearned = isLearned
        self.swipesCounter = swipesCounter
        self.id = id
    }

    init(coreData: WordCoreDataModel) {
        self.categoryId = coreData.categoryId ?? "1111"
        self.translations = coreData.translations ?? ["ru": "test", "en": "testtt"]
        self.isLearned = coreData.isLearned
        self.swipesCounter = Int(coreData.swipesCounter)
        self.id = coreData.id ?? "111"
    }
}
