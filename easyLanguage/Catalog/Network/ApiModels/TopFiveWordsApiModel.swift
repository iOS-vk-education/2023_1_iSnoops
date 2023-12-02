//
//  TopFiveWordsApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct TopFiveWordsApiModel: Decodable {
    let topFiveWordsId: Int
    let title: [String: String]
    let level: String
}
