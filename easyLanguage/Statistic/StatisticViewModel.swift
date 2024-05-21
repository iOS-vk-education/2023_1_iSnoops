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

    @Published var uiModel = StatisticUIModel()
    @Published var isLoaded = false

//    func getData() async throws {
//        let model: StatisticModel = try await service.loadWordsAndCategories()
//        await MainActor.run {
//            uiModel = StatisticUIModel(categories: model.categories,
//                                       words: model.allWords,
//                                       learnedWords: model.learned,
//                                       pieBarData: makeDataForPieBar(all: Double(model.allWords.count),
//                                                                     learned: Double(model.learned.count)),
//                                       barMarkData: makeDataForBarMark(dictionary: model.categoriesAndWords))
//            isLoaded = true
//        }
//    }
    func getDataCD() {
        let categoryDict: [String: Int] = service.loadCategoriesFromCD()
        let wordsArray = service.loadWordsFromCD()
        let learningWordsArray = service.loadLearningWordsFromCD()
            uiModel = StatisticUIModel(categories: categoryDict,
                                       words: wordsArray,
                                       learnedWords: learningWordsArray,
                                       pieBarData: makeDataForPieBar(all: Double(wordsArray.count),
                                                                     learned: Double(learningWordsArray.count)),
                                       barMarkData: makeDataForBarMark(dictionary: categoryDict))
            isLoaded = true
    }


    private func makeDataForPieBar(all: Double,
                                   learned: Double) -> [[PieBarValues]] {
                [[PieBarValues(value: 1.0,
                              color: .blue,
                              clockwise: true)],
                [PieBarValues(value: learned / all,
                              color: .green,
                              clockwise: true),
                 PieBarValues(value: (all - learned) / all,
                              color: .orange,
                              clockwise: true)]]
    }

    private func makeDataForBarMark(dictionary: [String: Int]) -> [STCategoriesWords] {
        var returnArray = [STCategoriesWords]()
        for key in dictionary.keys {
            returnArray.append(STCategoriesWords(countAdded: dictionary[key] ?? 0, name: key))
        }
        returnArray.sort { $0.countAdded > $1.countAdded }
        return returnArray
    }
}
