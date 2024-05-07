//
//  StatisticVIew.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 12.04.2024.
//

import Foundation
import SwiftUI
import Charts

struct StatisticView: View {
    @ObservedObject var model = StatisticViewModel()
    var body: some View {
        if model.isLoaded {
            List {
                CategoriesWordsChart(viewModel: model)
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("wordRatio", comment: ""))
                        .padding()
                        .font(.system(.title3, weight: .semibold))
                    HStack(spacing: 30) {
                        Spacer()
                        MainPieBar(text: NSLocalizedString("totalWords", comment: ""),
                                   sum: "\(model.words.count)",
                                   data: model.pieBarData)
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        LegendElement(color: .green,
                                      text: NSLocalizedString("learned", comment: ""))
                        LegendElement(color: .orange,
                                      text: NSLocalizedString("process", comment: ""))
                    }
                }
            } .listStyle(.automatic)
                .listRowSpacing(20)
                .refreshable {
                    loadWordsAndCategories()
                }
                .animation(.easeIn, value: model.pieBarData)
        } else {
            SwiftUI.ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    loadWordsAndCategories()
                }
        }
    }

    private func loadWordsAndCategories() {
        Task {
            do {
                try await model.getData()
            } catch {
               fatalError()
            }
        }
    }
}

struct LegendElement: View {
    var color: Color
    var text: String?
    var body: some View {
        HStack(spacing: 2) {
            Text("⬤").foregroundColor(color).font(.system(size: 6))
            Text("\(text ?? "error")").lineLimit(1)
        }
    }
}
