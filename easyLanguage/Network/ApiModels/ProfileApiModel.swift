//
//  ProfileApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct ProfileApiModel: Codable {
    let name: String
    let email: String
    let password: String
    let imageLink: String
    let systemMode: SystemMode
}

enum SystemMode: Codable {
    case lightTheme
    case systemTheme
    case darkTheme
}
