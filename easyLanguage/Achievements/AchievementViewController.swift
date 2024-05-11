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
    @State private var statisticButtonColor = SwiftUI.Color.gray
    @State private var achievementButtonColor = SwiftUI.Color.blue

    var achievements: [Achievement] = testData

    var body: some View {
            List(achievements) { ach in
                HStack (spacing: 15) {
                    Image(ach.imageName)
                        .resizable()
                        .frame(width: 36, height: 40)
                    Text(ach.text)
                        .frame(height: 50)
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
