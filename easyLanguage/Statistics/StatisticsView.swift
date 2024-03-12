//
//  StatisticsView.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 11.03.2024.
//

import Foundation
import SwiftUI
import Charts

struct StatisticModel {
    let name: String?
    let wordCount: String?
    let categoriesAdded: String?
    let learnedCount: String?
    let likedCat: String?
}

struct StatisticsView: View {
    var model: StatisticModel
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("Привет, \(model.name ?? "")!")
                        .fontWeight(.light)
                        .font(.system(size: 30))
                    Text("За все время с нами:")
                        .fontWeight(.light)
                        .font(.system(size: 30))
                }
                TextWithNumber(text: "Добавлено слов:",
                               number: model.wordCount ?? "")
                TextWithNumber(text: "Добавлено категорий:",
                               number: model.categoriesAdded ?? "")
                TextWithNumber(text: "Выучено слов:",
                               number: model.learnedCount ?? "")
                TextWithNumber(text: "Любимая категория:",
                               number: model.likedCat ?? "")
            }
        }
    }
}

struct TextWithNumber: View {
    var text: String
    var number: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .fontWeight(.light)
                .font(.system(size: 30))
            Text(number)
                .font(.system(size: 60))
        }.frame(width: 300, height: 100, alignment: .leading)
    }
}

// struct LearnedCorrBar: View {
//    var model: StatisticModel
//    var body: some View {
//        Chart { in
//            SectorMark(angle: .value("Value", wordCount))
//                .foregroundStyle(by: .value("Product category", learnedCount))
//        }
//        .frame(height: 300)
//    }
// }

#Preview {
    //    TextWithNumber(text: "Выучено слов",
    //                   number: "50")
    StatisticsView(model: StatisticModel(name: "Матвей",
                                         wordCount: "50",
                                         categoriesAdded: "5",
                                         learnedCount: "10",
                                         likedCat: "IT"))
}
