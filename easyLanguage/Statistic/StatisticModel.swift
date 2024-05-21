//
//  model.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation

struct STCategoriesWords: Identifiable {
    let id = UUID()
    let countAdded: Int
    let name: String
}

struct StatisticUIModel {
    var categories: [String: Int]?
    var words: [WordApiModel]?
    var learnedWords: [WordApiModel]?
    var pieBarData: [[PieBarValues]]?
    var barMarkData: [STCategoriesWords]?
}

struct StatisticModel {
    let categories: [CategoryApiModel]
    let categoriesAndWords: [String: Int]
    let allWords: [WordApiModel]
    let learned: [WordApiModel]
}


