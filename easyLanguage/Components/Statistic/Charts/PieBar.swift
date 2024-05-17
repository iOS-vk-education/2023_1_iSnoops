//
//  PieBar.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 06.05.2024.
//

import Foundation
import SwiftUI

struct PieBarValues: Hashable {
    var value: Double
    var color: Color
    var clockwise: Bool
}

struct MainPieBar: View {
    var text: String
    var sum: String
    var data: [[PieBarValues]]
    @State var isAnimated: Bool = true

    private enum Constants {
        static let lineWidth: CGFloat = 15
        static let lineSpace: CGFloat = 2
        static let radius: CGFloat = 243
    }

    // MARK: View
    var body: some View {
        ZStack {
            ForEach(data.indices, id: \.self) { index in
                ForEach(data[index].indices, id: \.self) { indexDelta in
                    PieBarItem(trimFrom: anim(computeTrimFrom(data: data[index],
                                                              index: indexDelta,
                                                              indexDelta: index)),
                               trimTo: anim(computeTrimTo(data: data[index],
                                                          index: indexDelta,
                                                          indexDelta: index)),
                               scaleEffect: data[index][indexDelta].clockwise ? 1 : -1,
                               lineWidth: Constants.lineWidth,
                               color: data[index][indexDelta].color,
                               itemPadding: computeLevel(index))
                }
            }
            VStack {
                Text("\(text)").font(.body)
                    .bold()
                Text("\(sum)").font(.title)
                    .bold()
            }.foregroundColor(.gray)
                .frame(width: calculateSideLength(),
                       height: calculateSideLength())
        }.onAppear {
            isAnimated = false
        }.frame(width: Constants.radius,
                height: Constants.radius)
    }

    // MARK: Private functions

    // Ширина и высота графика
    private func calculateSideLength() -> Double {
        Constants.radius - (computeLevel(data.count) * 2)
    }
    // Анимируем построения "кругов"
    private func anim(_ val: CGFloat) -> CGFloat {
        return isAnimated ? 0 : val
    }

    // Рассчитывает уровень каждого "круга" в зависимости от номера в массиве данными
    // level - номер элемента в массиве

    private func computeLevel(_ level: Int) -> CGFloat {
        return (Constants.lineWidth + Constants.lineSpace) * CGFloat(level)
    }

    // рассчитываем точку окончания построения каждого "круга"
    // data - массив данных
    // index - индекс вложенного массива
    // indexDelta - индекс элементов вложенного массива

    private func computeTrimTo(data: [PieBarValues], index: Int, indexDelta: Int) -> CGFloat {
        let delta = getDelta(indexOut: indexDelta)
        var sum: Double = 0
        if data.count == 1 {
            if data[index].value == 1 {
                sum = data[index].value
            } else {
                sum = data[index].value - delta
            }
        } else {
            if index == 0 {
                sum = data[index].value - delta
            } else {
                sum = data.prefix(index + 1).reduce(0, { $0 + $1.value }) - delta
            }
        }
        return sum
    }

    // рассчитываем точку начала построения каждого "круга"
    // data - массив данных
    // index - индекс вложенного массива
    // indexDelta - индекс элементов вложенного массива

    private func computeTrimFrom(data: [PieBarValues], index: Int, indexDelta: Int) -> CGFloat {
        let delta = getDelta(indexOut: indexDelta)
        var sum: Double = 0
        if data.count == 1 {
            if data[index].value != 1 {
                sum = delta
            }
        } else {
            if index == 0 {
                sum = delta
            } else {
                sum = data.prefix(index).filter({ $0.value > delta * 2 }).reduce(0, { $0 + $1.value }) + delta
            }
        }
        return sum
    }

    // рассчитываем дельту - отступ между "кругами" на одном уровне
    // indexOut - индекс вложенного массива

    private func getDelta(indexOut: Int) -> CGFloat {
        let calcWidth = calculateSideLength()
        let delta = (asin(Constants.lineWidth * 0.5 / ((calcWidth - Constants.lineWidth) * 0.5))) * (180 / .pi) / 360
        return delta
    }
}

struct PieBarItem: View {
    private enum Constants {
        static let angleDegrees: CGFloat = 270
        static let animDuration = 0.5
    }
    var trimFrom: CGFloat
    var trimTo: CGFloat
    var scaleEffect: CGFloat
    @State var lineWidth: CGFloat
    @State var color: Color
    @State var itemPadding: CGFloat = 0
    @State var rotation: CGFloat = 0
    var body: some View {
        Circle()
            .trim(from: trimFrom, to: min(trimTo, 1))
            .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       lineJoin: .round))
            .foregroundColor(color)
            .rotationEffect(Angle(degrees: Constants.angleDegrees + rotation))
            .animation(.linear(duration: Constants.animDuration),
                       value: trimTo)
            .padding(itemPadding)
            .scaleEffect(x: scaleEffect)
    }
}
