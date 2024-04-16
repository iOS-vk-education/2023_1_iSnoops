//
//  StatisticViewModel.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation
import SwiftUI 

class StatisticViewModel: ObservableObject {
    @Published var viewIsLoad = false
    @Published var model: StatisticModel = StatisticModel(countOfLearningWordsOnDate: ["1.03": 1,
                                                                                       "2.03": 0,
                                                                                       "3.03": 2,
                                                                                       "4.03": 1,
                                                                                       "5.03": 0,
                                                                                       "6.03": 2,
                                                                                       "7.03": 1],
                                                          countOfAddedWordsOnDate: ["1.03": 5,
                                                                                    "2.03": 10,
                                                                                    "3.03": 10,
                                                                                    "4.03": 10,
                                                                                    "5.03": 10,
                                                                                    "6.03": 0,
                                                                                    "7.03": 0],
                                                          weekStat: ["1.Пн": 1,
                                                                     "2.Вт": 3,
                                                                     "3.Ср": 5,
                                                                     "4.Чт": 0,
                                                                     "5.Пт": 2,
                                                                     "6.Сб": 3,
                                                                     "7.Вс": 0])
    @Published var doneDataLearning: [STLearningWords] = []
    @Published var doneDataAdded: [STAddedWords] = []
    @Published var doneDataWeek: [STLearningWords] = []
    @Published var photo: Photo = Photo(image: Image(uiImage: UIImage()))

    private func makeSimpleDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "DD-MM"
        return formatter.string(from: date)
    }

    func dayOfWeek(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

    func makeScreenshot(view: some View) {
        photo = Photo(image: Image(uiImage: view.snapshot()))
    }

    func makeDataForView(view: some View) {
        for data in model.countOfLearningWordsOnDate {
            self.doneDataLearning.append(STLearningWords(countLearning: data.value, date: data.key))
        }
        self.doneDataLearning.sort { $0.date > $1.date }
        for data in model.countOfAddedWordsOnDate {
            self.doneDataAdded.append(STAddedWords(countAdded: data.value, date: data.key))
        }
        self.doneDataAdded.sort { $0.date > $1.date }
        for data in model.weekStat {
            self.doneDataWeek.append(STLearningWords(countLearning: data.value, date: data.key))
        }
        self.doneDataWeek.sort { $0.date > $1.date }
        viewIsLoad = true
    }
}
