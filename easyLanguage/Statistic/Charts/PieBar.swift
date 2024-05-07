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

    let lineWidth: CGFloat = 15
    let lineSpace: CGFloat = 2
    let radius: CGFloat = 243

    // MARK: View

    var body: some View {
        ZStack {
            ForEach(data.indices, id: \.self) { index in
                ForEach(data[index].indices, id: \.self) { index1 in
                    PieBarItem(trimFrom: anim(computeTrimFrom(data: data[index],
                                                              index: index1,
                                                              indexDelta: index)),
                               trimTo: anim(computeTrimTo(data: data[index],
                                                          index: index1,
                                                          indexDelta: index)),
                               scaleEffect: data[index][index1].clockwise ? 1 : -1,
                               lineWidth: lineWidth,
                               color: data[index][index1].color,
                               itemPadding: computeLevel(index))
                }
            }
            VStack {
                Text("\(text)").font(.body)
                    .bold()
                Text("\(sum)").font(.title)
                    .bold()
            }.foregroundColor(.gray)
                .frame(width: radius - (computeLevel(data.count) * 2),
                       height: radius - (computeLevel(data.count) * 2))
        }.onAppear {
            isAnimated = false
        }.frame(width: radius, height: radius)
    }

    // MARK: Functions

    // Анимируем построения "кругов"
    private func anim(_ val: CGFloat) -> CGFloat {
        return isAnimated ? 0 : val
    }

    // Рассчитывает уровень каждого "круга" в зависимости от номера в массиве данными
    // level - номер элемента в массиве

    private func computeLevel(_ level: Int) -> CGFloat {
        return (lineWidth+lineSpace) * CGFloat(level)
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
                for point in 0..<index {
                    sum += data[point].value
                }
                sum = data[index].value + sum - delta
            }
        }
        return sum
    }

    // рассчитываем точку начала построения каждого "круга"
    // data - массив данных
    // index - индекс вложенного массива
    // indexDelta - индекс элементов вложенного массива

    private  func computeTrimFrom(data: [PieBarValues], index: Int, indexDelta: Int) -> CGFloat {
        let delta = getDelta(indexOut: indexDelta)
        var sum: Double = 0
        if data.count == 1 {
            if data[index].value == 1 {
                sum = 0
            } else {
                sum = delta
            }
        } else {
            if index == 0 {
                sum = delta
            } else {
                for point in 0..<index {
                    if delta * 2 >= data[point].value {
                        continue
                    }
                    sum += data[point].value
                }
                sum += delta
            }
        }
        return sum
    }

    // рассчитываем дельту - отступ между "кругами" на одном уровне
    // indexOut - индекс вложенного массива

    private func getDelta(indexOut: Int) -> CGFloat {
        let calcWidth = radius - (computeLevel(indexOut) * 2)
        let delta =  (((asin(lineWidth * 0.5 / ((calcWidth - lineWidth) * 0.5))) * (180 / .pi)) / 360) // 0.0083
        return delta
    }

    private func workWithSmallData(data: [[PieBarValues]]) -> [[PieBarValues]] {
        var returnData: [[PieBarValues]] = data
        for levelIndex in 0..<returnData.count {
            returnData[levelIndex].sort {$0.value < $1.value}
            for pie in 0..<returnData[levelIndex].count
            where returnData[levelIndex][pie].value <= getDelta(indexOut: levelIndex) * 2 {
                returnData[levelIndex][0].value += returnData[levelIndex][pie].value
            }
        }
        for levelIndex in 0..<returnData.count {
            returnData[levelIndex].removeAll {$0.value <= getDelta(indexOut: levelIndex) * 2}
        }
        return returnData
    }
}

struct PieBarItem: View {
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
            .rotationEffect(Angle(degrees: 270 + rotation))
            .animation(.linear(duration: 0.5),
                       value: trimTo)
            .padding(itemPadding)
            .scaleEffect(x: scaleEffect)
    }
}
