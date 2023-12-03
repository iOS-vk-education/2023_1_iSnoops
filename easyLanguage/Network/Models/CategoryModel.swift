//
//  CategoryModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.11.2023.
//

import Foundation

struct CategoryModel {
    let categoryId: Int
    let title: [String: String]
    let imageLink: String
    let studiedWordsCount: Int
    let totalWordsCount: Int
}
