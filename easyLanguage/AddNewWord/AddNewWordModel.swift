//
//  AddNewWordModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import Foundation

final class AddNewWordModel {
    private let addNewWordService = AddNewWordService.shared

    func addNewWord(with model: WordUIModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let wordAPIModel = WordApiModel(categoryId: model.categoryId,
                                        translations: model.translations,
                                        isLearned: model.isLearned,
                                        id: model.id)
        addNewWordService.addNewWord(with: wordAPIModel, completion: completion)
    }

    func translate(
        with word: String,
        isNative: Bool,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        addNewWordService.apiTranslation(with: word, isNative: isNative, completion: completion)
    }
}
