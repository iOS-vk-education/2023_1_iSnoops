//
//  WordModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

struct WordModel {
    let wordId: Int?
    let linkedWordsId: String // Связующий идентификатор для связи с категорией
    let words: [String: String]
    let isLearned: Bool
    let createdDate: Date
}
