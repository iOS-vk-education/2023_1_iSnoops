//
//  CategoryUIModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.11.2023.
//

import UIKit

final class CategoryUIModel {
    let categoryId: Int
    let title: [String: String]
    let image: UIImage?
    let studiedWordsCount: Int
    let totalWordsCount: Int

    init(categoryId: Int = 0,
         title: [String: String] = [:],
         image: UIImage? = nil,
         studiedWordsCount: Int = 0,
         totalWordsCount: Int = 0) {

        self.categoryId = categoryId
        self.title = title
        self.image = image
        self.studiedWordsCount = studiedWordsCount
        self.totalWordsCount = totalWordsCount
    }
}
