//
//  ProfileApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct ProfileApiModel: Codable {
    let profileId: String
    let name: String
    let email: String
    let imageLink: String
    let linkedCategoriesId: String //UUID для Categories
    let linkedTopFiveWords: String //UUID для TopFiveWords
    let systemMode: SystemMode
}

enum SystemMode: Codable {
    case lightTheme
    case systemTheme
    case darkTheme
}
