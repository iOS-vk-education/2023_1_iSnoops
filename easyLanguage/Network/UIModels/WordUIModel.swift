//
//  WordUIModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 25.11.2023.
//

import Foundation

struct WordUIModel {
    let categoryId: String // Связующий идентификатор для связи с категорией
    let translations: [String: String]
    var isLearned: Bool
    let id: String // для лайка
}

// FIXME: - нужно везде по-хорошему передавать опционал, но пока лень везде менять(((
struct OptionalWordUIModel {
    let categoryId: String // Связующий идентификатор для связи с категорией
    let translations: [String: String?]
    var isLearned: Bool
    let id: String // для лайка
}
