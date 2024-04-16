//
//  StatisticVIew.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 12.04.2024.
//

import Foundation
import SwiftUI
import Charts

#Preview {
    StatisticView()
}

struct StatisticView: View {
    @ObservedObject var model = StatisticViewModel()
    var body: some View {
        ScrollView(.vertical) {
            LearningAddedChart(viewModel: model)
                .padding()
            WeekStatisticChart(viewModel: model)
                .padding()
            ShareLink(item: model.photo,
                      preview: SharePreview("Статистика",
                                            image: model.photo))
            Button("Сделать скриншот") {
                model.makeScreenshot(view: self)
            }
        }
        .onAppear {
            model.makeDataForView(view: self)
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .white

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct Photo: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }

    public var image: Image
}
