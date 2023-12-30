//
//  CategoryUIModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.11.2023.
//

import UIKit

struct CategoryUIModel {
    let title: String
    let image: UIImage?
    let studiedWordsCount: Int
    let totalWordsCount: Int
    let index: Int
    let linkedWordsId: String // Связующий идентификатор для слов в категории

    init(
        title: String = "",
        image: UIImage? = nil,
        studiedWordsCount: Int = 0,
        totalWordsCount: Int = 0,
        index: Int = 0,
        linkedWordsId: String = ""
    ) {

        self.title = title
        self.image = image
        self.studiedWordsCount = studiedWordsCount
        self.totalWordsCount = totalWordsCount
        self.index = index
        self.linkedWordsId = linkedWordsId
    }
}
