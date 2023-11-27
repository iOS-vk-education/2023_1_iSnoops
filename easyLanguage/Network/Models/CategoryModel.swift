//
//  CategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.11.2023.
//

import Foundation

struct CategoryModel {
    let title: [String: String]
    let imageLink: String?
    let studiedWordsCount: Int
    var totalWordsCount: Int
    let createdDate: Date
    let linkedWordsId: String // Связующий идентификатор для слов в категории
}
