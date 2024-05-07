//
//  CategoriesWordsChart.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation
import SwiftUI
import Charts

struct CategoriesWordsChart: View {
    @ObservedObject var viewModel: StatisticViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("wordsCategories", comment: ""))
                .font(.system(.title3, weight: .semibold))
                .padding()
            VStack {
                if !viewModel.barMarkData.isEmpty {
                    Chart {
                        ForEach(viewModel.barMarkData, id: \.id) { lineData in
                            BarMark(
                                x: .value("Название категории", lineData.name),
                                y: .value("Количество слов", lineData.countAdded)
                            )
                            .foregroundStyle(.mint)
                        }
                    }
                    .animation(.default)
                    .chartLegend(position: .automatic)
                } else {
                    VStack(alignment: .center) {
                        Text("Пусто!")
                    }
                }
            }.frame(height: 300)
        }
    }
}
