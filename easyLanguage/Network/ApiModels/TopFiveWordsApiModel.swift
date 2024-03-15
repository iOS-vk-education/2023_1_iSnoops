//
//  TopFiveWordsApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct TopFiveWordsApiModel: Decodable {
    let translate: [String: String]
    let userId: String
    let id: String
    let date: Date
}
