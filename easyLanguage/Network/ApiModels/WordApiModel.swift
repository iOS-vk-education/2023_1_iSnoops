//
//  WordApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 22.11.2023.
//

import Foundation

struct WordApiModel: Codable {
    let word: [String: String]
    let isLearned: Bool
    let createdDate: Date
}
