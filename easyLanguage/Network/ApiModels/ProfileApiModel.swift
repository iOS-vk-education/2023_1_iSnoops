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
    let imageLink: String?
    let systemMode: SystemMode

    init?(dict: [String: Any]) {
        guard
            let userId = dict["userId"] as? String,
            let username = dict["username"] as? String,
            let email = dict["email"] as? String,
            let imageLink = dict["imageLink"] as? String?
        else {
            return nil
        }

        self.profileId = userId
        self.name = username
        self.email = email
        self.imageLink = imageLink
        self.systemMode = .lightTheme
    }
}

enum SystemMode: Codable {
    case lightTheme
    case systemTheme
    case darkTheme
}
