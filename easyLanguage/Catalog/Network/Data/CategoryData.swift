//
//  CategoryData.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct CategoryData: Codable {
    let categoryId: Int
    let ruTitle: String
    let engTitle: String
    let imageLink: String?
    let studiedWordsCount: Int
    let totalWordsCount: Int
}
