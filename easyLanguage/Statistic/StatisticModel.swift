//
//  model.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation
import Charts

struct STCategoriesWords: Identifiable {
    let id = UUID()
    let countAdded: Int
    let name: String
    let datatype: DataType = .learned
}

enum DataType: String {
    case learned = "Категория"
}

extension DataType: Plottable {
    var primitivePlottable: String {
        rawValue
    }
}
