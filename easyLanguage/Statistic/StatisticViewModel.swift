//
//  StatisticViewModel.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation
import SwiftUI

class StatisticViewModel: ObservableObject {
    let service = StatisticService()

    @Published var isLoaded = false
    @Published var categories: [CategoryApiModel] = []
    @Published var words: [WordApiModel] = []
    @Published var learnedWords: [WordApiModel] = []
    @Published var pieBarData: [[PieBarValues]] = []
    @Published var barMarkData: [STCategoriesWords] = []

    func getData() async throws {
        let model: StatisticModel = try await service.loadWordsAndCategories()
        await MainActor.run {
            categories = model.categories
            barMarkData = makeDataForBarMark(dictionary: model.categoriesAndWords)
            words = model.allWords
            learnedWords = model.learned
            pieBarData = makeDataForPieBar(all: Double(words.count), learned: Double(learnedWords.count))
            isLoaded = true
        }
    }

    func makeDataForPieBar(all: Double, learned: Double) -> [[PieBarValues]] {
        return [[PieBarValues(value: 1.0,
                              color: .blue,
                              clockwise: true)],
                [PieBarValues(value: learned / all,
                              color: .green,
                              clockwise: true),
                 PieBarValues(value: (all - learned) / all,
                              color: .orange,
                              clockwise: true)]]
    }

    func makeDataForBarMark(dictionary: [String: Int]) -> [STCategoriesWords] {
        var returnArray = [STCategoriesWords]()
        for key in dictionary.keys {
            returnArray.append(STCategoriesWords(countAdded: dictionary[key] ?? 0, name: key))
        }
        returnArray.sort { $0.countAdded > $1.countAdded }
        return returnArray
    }
}
