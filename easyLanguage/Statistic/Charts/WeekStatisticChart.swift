//
//  WeekStatisticChart.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation
import SwiftUI
import Charts

struct WeekStatisticChart: View {
    @ObservedObject var viewModel: StatisticViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("Кол-во выученных слов за неделю")
                .font(.system(.title3, weight: .semibold))
            VStack {
                if !viewModel.model.countOfAddedWordsOnDate.isEmpty {
                    Chart {
                        ForEach(viewModel.doneDataWeek, id: \.date) { lineData in
                            BarMark(
                                x: .value("День недели", lineData.date),
                                y: .value("Количество слов", lineData.countLearning)
                            )
                            .foregroundStyle(by: .value("DataType", lineData.datatype))
                        }
                    }
                    .chartForegroundStyleScale(
                        [
                            DataType.learned: Color.green
                        ]
                    )
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
