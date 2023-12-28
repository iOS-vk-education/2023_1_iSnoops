//
//  ProfileUIModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import UIKit

struct ProfileUIModel {
    let name: String
    let email: String
    let password: String
    let avatar: UIImage
    let linkedCategoriesId: String //UUID для Categories
    let linkedTopFiveWords: String //UUID для TopFiveWords
    let systemMode: SystemUIModel
}

enum SystemUIModel {
    case lightTheme
    case systemTheme
    case darkTheme
}
