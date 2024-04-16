//
//  AddNewWordModels.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.04.2024.
//

import Foundation

enum AddNewWordViewEvent {
    /// View была загружена
    case viewLoaded
    /// Нажата кнопка переведа
    case translateButtonTapped(nativeText: String?, foreignText: String?)
    /// Нажата кнопка добавления слова
    case addNewCardTapped(wordUIModel: WordUIModel)
    /// Проверка является ли текст валидным ( для добавления карточки)
    case checkIsValidNativeText(text: String?, isNative: Bool)
}

enum AddNewWordInteractorEvent {
    /// Загружен экран
    case viewLoaded
    /// Показ ошибки
    case showAlert(message: String)
    /// Успешно добавлен перевод
    case addTranslate(text: String, isNative: Bool)
    /// Успешно добавлено новое слово
    case addNewWord(id: String)
}

enum AddNewWordPresenterEvent {
    /// показываем экран
    case showView
    /// показываем ошибку
    case showError(error: String)
    /// необходимо обновить вьюху с  переводом
    case updateNativeField(text: String, isNative: Bool)
    /// добавление нового слова на экран CategoryDetailViewController
    case updateCategoryDetail(id: String)
}
