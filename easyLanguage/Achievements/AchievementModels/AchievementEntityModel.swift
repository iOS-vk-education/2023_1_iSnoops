//
//  AchievementEntityModel.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 17.05.2024.
//

import Foundation

struct AchievementEntityModel: Identifiable {
    var id = UUID()
    var text: String
    var subtext: String
    var achievementModel: AchievementModel?
}
