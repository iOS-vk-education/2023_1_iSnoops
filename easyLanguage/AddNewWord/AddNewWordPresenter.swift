//
//  AddNewWordPresenter.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.04.2024.
//

import Foundation

protocol AddNewWordPresenterOutput: AnyObject {
    func handle(event: AddNewWordPresenterEvent)
}

final class AddNewWordPresenter {
    weak var view: AddNewWordPresenterOutput?
}

extension AddNewWordPresenter: AddNewWordInteractorOutput {
    func handle(event: AddNewWordInteractorEvent) {
        switch event {
        case .viewLoaded:
            view?.handle(event: .showView)
        case .showAlert(let message):
            view?.handle(event: .showError(error: message))
        case .addNativeTranslate(let text):
            view?.handle(event: .updateNativeField(text: text))
        case .addForeignTranslate(let text):
            view?.handle(event: .updateForeignField(text: text))
        case .addNewWord(id: let id):
            view?.handle(event: .updateCategoryDetail(id: id))
        }
    }
}
