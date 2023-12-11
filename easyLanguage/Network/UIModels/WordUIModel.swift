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
    let isLearned: Bool
}
