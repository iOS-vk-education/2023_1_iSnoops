//
//  CategoryUIModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.11.2023.
//

import UIKit

final class CategoryUIModel {
    let title: [String: String]
    let image: UIImage?
    let studiedWordsCount: Int
    let totalWordsCount: Int
    let createdDate: Date
    let linkedWordsId: String // Связующий идентификатор для слов в категории

    init(title: [String: String] = [:],
         image: UIImage? = nil,
         studiedWordsCount: Int = 0,
         totalWordsCount: Int = 0,
         createdDate: Date = Date(),
         linkedWordsId: String = "") {

        self.title = title
        self.image = image
        self.studiedWordsCount = studiedWordsCount
        self.totalWordsCount = totalWordsCount
        self.createdDate = createdDate
        self.linkedWordsId = linkedWordsId
    }
}
