//
//  CategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.11.2023.
//

import Foundation

struct CategoryModel {
    let title: String
    var imageLink: String?
    var studiedWordsCount: Int = 0
    var totalWordsCount: Int = 0
    var createdDate: Date = Date()
    var linkedWordsId: String = UUID().uuidString // Связующий идентификатор для слов в категории
    var index: Int? = 0
    var isDefault: Bool = false // Является ли категория созданной при регистрации
}
