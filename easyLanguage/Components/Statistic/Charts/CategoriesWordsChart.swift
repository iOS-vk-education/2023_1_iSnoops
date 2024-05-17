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
    private enum Sizes {
        static let height: CGFloat = 300
    }
    @ObservedObject var viewModel: StatisticViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("wordsCategories", comment: ""))
                .font(.system(.title3, weight: .semibold))
                .padding()
            VStack {
                if !(viewModel.uiModel.barMarkData?.isEmpty ?? false) {
                    Chart {
                        ForEach(viewModel.uiModel.barMarkData ?? [], id: \.id) { lineData in
                            BarMark(
                                x: .value(NSLocalizedString("statisticChartCategoryName", comment: ""), lineData.name),
                                y: .value(NSLocalizedString("statisticWordCount", comment: ""), lineData.countAdded)
                            )
                            .foregroundStyle(.mint)
                        }
                    }
                    .animation(.default)
                    .chartLegend(position: .automatic)
                } else {
                    VStack(alignment: .center) {
                        Text(NSLocalizedString("emptyChart", comment: ""))
                    }
                }
            }.frame(height: Sizes.height)
        }
    }
}
