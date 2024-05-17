//
//  CategoryData.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct CategoryApiModel: Codable {
    let title: String
    let imageLink: String?
    let createdDate: Date
    let linkedWordsId: String // Связующий идентификатор для слов в категории
    let isDefault: Bool
}
