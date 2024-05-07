//
//  LearningAddedChart.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 16.04.2024.
//

import Foundation
import SwiftUI
import Charts

//struct LearningAddedChart: View {
//    @ObservedObject var viewModel: StatisticViewModel
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Выучено/Добавлено")
//                .font(.system(.title3, weight: .semibold))
//            VStack {
//                if !viewModel.model.countOfAddedWordsOnDate.isEmpty {
//                    Chart {
//                        ForEach(viewModel.doneDataLearning, id: \.id) { lineData in
//                            LineMark(
//                                x: .value("День недели", lineData.date),
//                                y: .value("Количество слов", lineData.countLearning),
//                                series: .value("DataType", lineData.datatype)
//                            )
//                            .foregroundStyle(by: .value("DataType", lineData.datatype))
//                        }
//                        ForEach(viewModel.doneDataAdded, id: \.id) { lineData in
//                            LineMark(
//                                x: .value("День недели", lineData.date),
//                                y: .value("Количество слов", lineData.countAdded),
//                                series: .value("DataType", lineData.datatype)
//                            )
//                        }
//                    }
//                    .chartForegroundStyleScale(
//                        [
//                            DataType.added: Color.blue,
//                            DataType.learned: Color.red
//                        ]
//                    )
//                    .chartLegend(position: .automatic)
//                    .chartYAxis {
//                        AxisMarks(values: .automatic(desiredCount: 3))
//                    }
//                } else {
//                    VStack(alignment: .center) {
//                        Text("Пусто!")
//                    }
//                }
//            }.frame(height: 300)
//        }
//
//    }
//}
