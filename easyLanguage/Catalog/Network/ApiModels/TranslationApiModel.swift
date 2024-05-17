//
//  TranslationApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 15.03.2024.
//

import Foundation

struct TranslationResponse: Codable {
    let definitions: [Definition]?

    enum CodingKeys: String, CodingKey {
        case definitions = "def"
    }
}

struct Definition: Codable {
    let translations: [Translation]?

    enum CodingKeys: String, CodingKey {
        case translations = "tr"
    }
}

struct Translation: Codable {
    let text: String?
}
