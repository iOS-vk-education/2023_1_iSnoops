//
//  AddNewWordBuilder.swift
//  easyLanguage
//
//  Created by Grigoriy on 09.04.2024.
//

import Foundation

final class AddNewWordBuilder {

    //FIXME: - такие вещи (передаются в параметрах функциях) убрать или потом они нужны для тестов?
    static func build(categoryId: String = "",
                      addNewWordService: AddNewWordServiceProtocol? = nil,
                      word: String? = nil,
                      isNative: Bool? = nil,
                      wordUIModel: OptionalWordUIModel? = nil
    ) -> AddNewWordViewController {

        let viewController = AddNewWordViewController()
        viewController.categoryId = categoryId

        let service = AddNewWordService()

        let interactor = AddNewWordInteractor(
            addNewWordService: service,
            word: word,
            isNative: isNative,
            wordUIModel: wordUIModel
        )

        let presenter = AddNewWordPresenter()

        viewController.output = interactor
        interactor.presenter = presenter
        presenter.view = viewController

        return viewController
    }
}
