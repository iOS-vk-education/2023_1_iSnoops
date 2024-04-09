//
//  TopFiveWordsApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct TopFiveWordsApiModel: Decodable {
    let translate: [String: String] // слово - перевод
    let userId: String // id пользователя
    let id: String // id слова
    let date: Date // дата создания слова
}
