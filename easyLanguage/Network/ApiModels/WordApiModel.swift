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
    let id: String // для лайка
}
