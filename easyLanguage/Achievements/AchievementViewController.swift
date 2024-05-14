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
    var achievementModel: AchievementModel?
}

struct AchievementView: View {

    @State var answers: [AchievementModel] = []
    @State var achievements: [Achievement] = testData
    
    private enum Constants {
        static let marginLeft: CGFloat = 15
        static let imageWidth: CGFloat = 36
        static let imageHeight: CGFloat = 40
        static let textHeight: CGFloat = 50
    }


    var body: some View {
        List(achievements) { achievement in
            HStack(spacing: Constants.marginLeft) {
                Image((achievement.achievementModel?.isAchievementDone ?? false) ? "AchievementDone" : "AchievementNotDone")
                    .resizable()
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                Text(achievement.text)
                    .frame(height: Constants.textHeight)
            }
            .listRowBackground(SwiftUI.Color(UIColor.PrimaryColors.Background.background))
        }
        .listStyle(.plain)
        .onAppear {
            CategoriesModel().loadCategories { result in
                switch result {
                case .success(let categories):
                    answers = AchievementManager(categories: categories).getAnswers()
                    print(answers)
                    let combinedData = zip(testData, answers)
                    achievements = combinedData.map { testData, answer in
                        return Achievement(text: testData.text, achievementModel: answer)
                    }
                    print(testData)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    AchievementView()
}

#if DEBUG
var testData = [
    Achievement(text: "Создай свою собственную категорию", achievementModel: nil),
    Achievement(text: "Создай 5 категорий", achievementModel: nil),
    Achievement(text: "Изучи 10 слов", achievementModel: nil),
    Achievement(text: "Изучи 100 слов", achievementModel: nil),
    Achievement(text: "Изучи 500 слов и поезжай в Англию", achievementModel: nil),
    Achievement(text: "Добавь 50 слов в одну категорию", achievementModel: nil),
    Achievement(text: "Изучи полностью одну категорию", achievementModel: nil),
    Achievement(text: "Изучи полностью три категории", achievementModel: nil),
]
#endif
