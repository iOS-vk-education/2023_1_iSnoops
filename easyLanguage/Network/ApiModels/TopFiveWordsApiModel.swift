//
//  TopFiveWordsApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import Foundation

struct TopFiveWordsApiModel: Decodable {
    let translations: [String: String]
    let profileId: String  //UUID linkedTopFiveWords
}
