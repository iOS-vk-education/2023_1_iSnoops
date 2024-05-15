//
//  AchievementViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 26.03.2024.
//

import Foundation
import SwiftUI

struct Achievement: Identifiable {
    var id = UUID()
    var text: String
    var imageName: String
}

struct AchievementView: View {

    private enum Constants {
        static let marginLeft: CGFloat = 15
        static let imageWidth: CGFloat = 36
        static let imageHeight: CGFloat = 40
        static let textHeight: CGFloat = 50
    }

    var achievements: [Achievement] = testData

    var body: some View {
        List(achievements) { ach in
            HStack(spacing: Constants.marginLeft) {
                Image(ach.imageName)
                    .resizable()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                Text(ach.text)
                    .frame(height: Constants.textHeight)
            }
            .listRowBackground(SwiftUI.Color(UIColor.PrimaryColors.Background.background))
        }
        .listStyle(.plain)
    }
}

#Preview {
    AchievementView()
}

#if DEBUG
let testData = [
    Achievement(text: "Создай свою собственную категорию", imageName: "AchievementCompletionIcon"),
    Achievement(text: "Изучи 10 слов", imageName: "AchievementCompletionIcon"),
    Achievement(text: "Изучи 100 слов", imageName: "AchievementCompletionIcon"),
    Achievement(text: "Изучи 500 слов", imageName: "AchievementNotDone"),
    Achievement(text: "Достигни уровня С2", imageName: "AchievementNotDone")
]
#endif
