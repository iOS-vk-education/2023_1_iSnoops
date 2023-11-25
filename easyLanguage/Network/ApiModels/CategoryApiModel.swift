//
//  CategoryData.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct CategoryApiModel: Codable {
    let categoryId: Int // PK
    let title: [String: String]
    let imageLink: String?
    let studiedWordsCount: Int
    let totalWordsCount: Int
    let createdDate: Date
    let linkedWordsId: String // Связующий идентификатор для слов в категории
}
