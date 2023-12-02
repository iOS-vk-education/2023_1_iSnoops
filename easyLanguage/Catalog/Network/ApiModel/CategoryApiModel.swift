//
//  CategoryData.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct CategoryApiModel: Codable {
    let categoryId: Int
    let title: [String: String]
    let imageLink: String?
    let studiedWordsCount: Int
    let totalWordsCount: Int
}
