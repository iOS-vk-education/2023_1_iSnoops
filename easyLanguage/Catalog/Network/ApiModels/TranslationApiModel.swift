//
//  TranslationApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 15.03.2024.
//

import Foundation

struct TranslationResponse: Codable {
    let def: [Definition]?
}

struct Definition: Codable {
    // swiftlint:disable:next identifier_name
    let tr: [Translation]?
}

struct Translation: Codable {
    let text: String?
}
