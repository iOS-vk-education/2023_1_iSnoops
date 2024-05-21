//
//  StatisticView.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 12.04.2024.
//

import Foundation
import SwiftUI
import Charts

struct StatisticView: View {

    private enum Constants {
        static let listSpacing: CGFloat = 20
        static let listMarginLeft: CGFloat = 30
    }

    @ObservedObject var model = StatisticViewModel()
    var body: some View {
        if model.isLoaded {
            VStack {
                CategoriesWordsChart(viewModel: model)
                    .listRowBackground(SwiftUI.Color(UIColor.PrimaryColors.Background.background))
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("wordRatio", comment: ""))
                        .padding()
                        .font(.system(.title3, weight: .semibold))
                    HStack(spacing: Constants.listMarginLeft) {
                        Spacer()
                        MainPieBar(text: NSLocalizedString("totalWords", comment: ""),
                                   sum: "\(model.uiModel.words?.count ?? 0)",
                                   data: model.uiModel.pieBarData ?? [])
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        LegendElement(color: .green,
                                      text: NSLocalizedString("learned", comment: ""))
                        LegendElement(color: .orange,
                                      text: NSLocalizedString("process", comment: ""))
                    }
                }
            }.padding()
                .onAppear {
                    model.getDataCD()
                }
            .animation(.easeIn, value: model.uiModel.pieBarData)
        } else {
            SwiftUI.ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear {
                    model.getDataCD()
                }
        }
    }

//    private func loadWordsAndCategories() {
//        Task {
//            do {
//                try await model.getData()
//            } catch {
//                fatalError()
//            }
//        }
//    }
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
