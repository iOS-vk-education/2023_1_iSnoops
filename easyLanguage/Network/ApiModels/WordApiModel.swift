//
//  WordApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import Foundation

struct WordApiModel: Codable {
    let wordId: Int // PK
    let linkedWordsId: String // Связующий идентификатор для связи с категорией
    let words: [String: String]
    var isLearned: Bool
    let createdDate: Date
}
