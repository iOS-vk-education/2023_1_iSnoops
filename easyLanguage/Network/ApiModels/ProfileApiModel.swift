//
//  ProfileApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct ProfileApiModel: Codable {
    let name: String
    let lastName: String
    let email: String
    let password: String
    let imageLink: String
    let linkedCategoriesId: [String]
    let systemMode: SystemMode
    let learningLanguage: LearningLanguage
}

enum SystemMode: Codable {
    case lightTheme
    case systemTheme
    case darkTheme
}

enum LearningLanguage: String, Codable {
    case english = "en"
    case russian = "ru"
}
