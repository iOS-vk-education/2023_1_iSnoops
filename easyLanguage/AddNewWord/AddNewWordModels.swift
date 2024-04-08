//
//  AddNewWordModels.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.04.2024.
//

import Foundation

enum AddNewWordViewEvent {
    /// VIew была загружена
    case viewLoaded
    /// Нажата кнопка переведа
    case translateButtonTapped(word: String, isNative: Bool)
    /// Нажата кнопка добавления слова
    case addNewCardTapped(wordUIModel: WordUIModel)
    /// Проверка на заполенение одного из полей перевода
    case translateCheckIsOptionText(_ nativeText: String?, _ foreignText: String?)
    /// Проверка является ли текст валидным ( для добавления карточки)
    case checkIsValidNativeText(text: String?, isNative: Bool) //FIXME: - как правильно возвращать значение?
}

enum AddNewWordInteractorEvent {
    /// Загружен экран
    case viewLoaded
    /// Показ ошибки
    case showAlert(message: String)
    /// Успешно добавлен перевод с родным языком
    case addNativeTranslate(text: String)
    /// Успешно добавлен перевод с иностранным языком
    case addForeignTranslate(text: String)
    /// Успешно добавлено новое слово
    case addNewWord(id: String)
}

enum AddNewWordPresenterEvent {
    /// показываем экран
    case showView
    /// показываем ошибку
    case showError(error: String)
    /// необходимо обновить вьюху с родным переводом
    case updateNativeField(text: String)
    /// необходимо обновить вьюху с иностранным переводом
    case updateForeignField(text: String)
    /// добавление нового слова на экран CategoryDetailViewController
    case updateCategoryDetail(id: String)
}
