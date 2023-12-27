//
//  CategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.11.2023.
//

import Foundation

struct CategoryModel {
    let title: String
    let imageLink: String?
    var studiedWordsCount: Int
    var totalWordsCount: Int
    let createdDate: Date
    let linkedWordsId: String // Связующий идентификатор для слов в категории
    let index: Int?
}
