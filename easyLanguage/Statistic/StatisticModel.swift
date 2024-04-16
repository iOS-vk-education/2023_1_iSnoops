//
//  model.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation
import Charts

struct STLearningWords: Identifiable {
    let id = UUID()
    let countLearning: Int
    let date: String
    let datatype: DataType = .learned
}

struct STAddedWords: Identifiable {
    let id = UUID()
    let countAdded: Int
    let date: String
    let datatype: DataType = .added
}

struct StatisticModel {
    let countOfLearningWordsOnDate: [String: Int]
    let countOfAddedWordsOnDate: [String: Int]
    let weekStat: [String: Int]
}

enum DataType: String {
    case learned
    case added
    case notSet
}

extension DataType: Plottable {
    var primitivePlottable: String {
        rawValue
    }
}
