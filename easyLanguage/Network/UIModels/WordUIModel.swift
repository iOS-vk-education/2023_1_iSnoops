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
}
