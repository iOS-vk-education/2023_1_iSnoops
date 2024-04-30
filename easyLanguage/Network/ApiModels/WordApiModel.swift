//
//  WordApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import Foundation

struct WordApiModel: Codable {
    let categoryId: String // Связующий идентификатор для связи с категорией
    let translations: [String: String]
    var isLearned: Bool
    var swipesCounter: Int
    let id: String // для лайка

    init(categoryId: String, translations: [String: String], isLearned: Bool, swipesCounter: Int, id: String) {
        self.categoryId = categoryId
        self.translations = translations
        self.isLearned = isLearned
        self.swipesCounter = swipesCounter
        self.id = id
    }

    init(ui: WordUIModel) {
        categoryId = ui.categoryId
        translations = ui.translations
        isLearned = ui.isLearned
        swipesCounter = ui.swipesCounter
        id = ui.id
    }
}
