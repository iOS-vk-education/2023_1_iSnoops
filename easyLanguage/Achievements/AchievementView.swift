//
//  AchievementView.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 26.03.2024.
//

import Foundation
import SwiftUI

struct AchievementView: View {

    @State var answers: [AchievementModel] = []
    @State var achievements: [AchievementEntityModel] = testData
    
    private enum Constants {
        static let marginLeft: CGFloat = 15
        static let imageWidth: CGFloat = 36
        static let imageHeight: CGFloat = 40
        static let textHeight: CGFloat = 50
    }

    var body: some View {
        List(achievements) { achievement in
            HStack(spacing: Constants.marginLeft) {
                if let achievementModel = achievement.achievementModel {
                    Image((achievementModel.isAchievementDone) ? "AchievementDone" : "AchievementNotDone")
                        .resizable()
                        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                } else {
                    SwiftUI.ProgressView()
                }
                Text(achievement.text)
                    .frame(height: Constants.textHeight)
            }
            .listRowBackground(SwiftUI.Color(UIColor.PrimaryColors.Background.background))
        }
        .listStyle(.plain)
        .onAppear {
            let categories = CategoriesModel().loadCDCategories()
            answers = AchievementManager(categories: categories).getAnswers()
            let combinedData = zip(testData, answers)
            achievements = combinedData.map { testData, answer in
                return AchievementEntityModel(text: testData.text, achievementModel: answer)
            }
        }
    }
}

#Preview {
    AchievementView()
}

#if DEBUG
var testData = [
    AchievementEntityModel(text: NSLocalizedString( "createOneCategoryLabel", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "createFiveCategoriesLabel", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnTenWordsLabel", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnOneHundredWordsLabel", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnFiveHundredWordsLabel", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "createFiftyWordsInOneCategoryLabel", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnOneCategoryLabel", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnThreeCategoriesLabel", comment: ""), achievementModel: nil)
]
#endif
