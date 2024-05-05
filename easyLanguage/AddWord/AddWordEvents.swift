//
//  AddWordEvents.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.04.2024.
//

import Foundation

typealias WordType = (word: String, native: Bool)

// MARK: - View Output

protocol AddWordViewOutput {
    func handle(event: AddWordViewOutputEvent)
}

enum AddWordViewOutputEvent {
    /// View была загружена
    case viewLoaded
    /// Нажата кнопка переведа
    case translateButtonTapped(native: String, foreign: String)
    /// Нажата кнопка добавления слова
    case addButtonTapped(uiModel: WordUIModel)
    /// Является ли слово валидным для карточки
    case checkIsValid(WordType)
}

// MARK: - View Input

protocol AddWordViewInput: AnyObject {
    func handle(event: AddWordViewInputEvent)
}

enum AddWordViewInputEvent {
    /// Показ экрана
    case showView
    /// Обновление поля с переводом
    case updateField(WordType)
    /// Добавление нового слова на экран CategoryDetailViewController
    case updateCategoryDetail(id: String)
    /// Показ ошибки
    case showAlert(message: String)
}
