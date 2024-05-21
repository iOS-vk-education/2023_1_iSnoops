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
        static let textHeight: CGFloat = 20
    }

    var body: some View {
        LazyVStack(alignment: .leading) {
                ForEach(achievements) { achievement in
                    HStack(spacing: Constants.marginLeft) {
                        if let achievementModel = achievement.achievementModel {
                            Image((achievementModel.isAchievementDone) ? "AchievementDone" : "AchievementNotDone")
                                .resizable()
                                .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                        } else {
                            SwiftUI.ProgressView()
                        }
                        VStack(alignment: .leading) {
                            Text(achievement.text)
                                .frame(height: Constants.textHeight)
                            Text("\(achievement.subtext): \(achievement.achievementModel?.count ?? 0)/\(achievement.achievementModel?.required ?? 0)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }.padding([.top, .leading, .trailing])
                }
            .listRowBackground(SwiftUI.Color(UIColor.PrimaryColors.Background.background))

        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .onAppear {
            let categories = CategoriesModel().loadCDCategories()
            answers = AchievementManager(categories: categories).getAnswers()
            let combinedData = zip(testData, answers)
            achievements = combinedData.map { testData, answer in
                return AchievementEntityModel(text: testData.text, subtext: testData.subtext, achievementModel: answer)
            }
        }
    }
}

#Preview {
    AchievementView()
}

#if DEBUG
var testData = [
    AchievementEntityModel(text: NSLocalizedString( "createOneCategoryLabel", comment: ""),
        subtext: NSLocalizedString("created", comment: ""),
        achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "createFiveCategoriesLabel", comment: ""),
        subtext: NSLocalizedString("created", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnTenWordsLabel", comment: ""),
        subtext: NSLocalizedString("learned", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnOneHundredWordsLabel", comment: ""),
        subtext: NSLocalizedString("learned", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnFiveHundredWordsLabel", comment: ""),
        subtext: NSLocalizedString("learned", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "createFiftyWordsInOneCategoryLabel", comment: ""),
        subtext: NSLocalizedString("added", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnOneCategoryLabel", comment: ""),
        subtext: NSLocalizedString("explored", comment: ""), achievementModel: nil),
    AchievementEntityModel(text: NSLocalizedString( "learnThreeCategoriesLabel", comment: ""),
        subtext: NSLocalizedString("explored", comment: ""), achievementModel: nil)
]
#endif
