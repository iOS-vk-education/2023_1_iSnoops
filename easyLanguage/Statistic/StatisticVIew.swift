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
        List {
            CategoriesWordsChart(viewModel: model)
            VStack(alignment: .leading) {
                Text("Соотношение слов")
                    .padding()
                    .font(.system(.title3, weight: .semibold))
                HStack(spacing: 30) {
                    MainPieBar(text: "sd", sum: "ds", data: model.pieBarData)
                    VStack {
                        BottomPercentsElement(color: .green, text: "Выучено")
                        BottomPercentsElement(color: .orange, text: "В обучении")
                    }.frame(width: 80, alignment: .leading)
                }
            }
            ShareLink(item: model.photo,
                      preview: SharePreview("Статистика",
                                            image: model.photo))
            Button("Сделать скриншот") {
                model.makeScreenshot(view: self)
            }
            .onAppear {
                loadWordsAndCategories()
            }
        } .listStyle(.automatic)
            .listRowSpacing(20)
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


struct BottomPercentsElement: View {
    var color: Color
    var text: String?
    var body: some View {
        HStack(spacing: 2) {
            Text("⬤").foregroundColor(color).font(.system(size: 6))
            Text("\(text ?? "error")").lineLimit(1)
        }
    }
}
