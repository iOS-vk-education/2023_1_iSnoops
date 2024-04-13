//
//  AchievementViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 26.03.2024.
//

import Foundation
import SwiftUI

struct Achievement: Identifiable{
    var id = UUID()
    var text: String
    var imageName: String
}

struct ContentView: View {
    @State private var statisticButtonColor = SwiftUI.Color.gray
    @State private var achievementButtonColor = SwiftUI.Color.blue

    var achievements: [Achievement] = testData
    
    var body: some View {
        VStack {
            Image(systemName: "sun.max.circle.fill")
                .font(.system(size: 90))
                .foregroundStyle(.cyan)
                .padding(.bottom, 5)
            Text("Арсений").bold()
                .font(.title)
                .padding(.bottom, 10)
            HStack {
                Button("Статистика") {
                    statisticButtonColor = .blue
                    achievementButtonColor = .gray
                }
                .font(.title3)
                .foregroundStyle(statisticButtonColor)
                .padding(.trailing, 10)
                Button("Достижения") {
                    statisticButtonColor = .gray
                    achievementButtonColor = .blue
                }
                .font(.title3)
                .foregroundStyle(achievementButtonColor)
            }
            List(achievements) { ach in
//                let image = UIImage(named: ach.imageName)
                HStack {
                    Image(ach.imageName)
                    Text(ach.text)
                }
            }.listStyle(.plain)
//            .foregroundStyle(.white)
            
//            achievements.forEach {
//                Text($0.text)
//            }
            Spacer()
        }
        .padding()
    }
}


#Preview {
    ContentView()
}

#if DEBUG
let testData = [
    Achievement(text: "Создай свою собственную категорию", imageName: "AchievementCompletionIcon"),
    Achievement(text: "Изучи 10 слов", imageName: "AchievementCompletionIcon"),
    Achievement(text: "Изучи 100 слов", imageName: "AchievementNotDone"),
    Achievement(text: "Изучи 500 слов", imageName: "AchievementNotDone"),
    Achievement(text: "Достигни уровня С2", imageName: "AchievementCompletionIcon")
]
#endif
