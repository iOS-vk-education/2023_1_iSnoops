//
//  AddWordBuilder.swift
//  easyLanguage
//
//  Created by Grigoriy on 09.04.2024.
//

import Foundation

final class AddWordBuilder {
    static func build(categoryID: String) -> AddWordViewController {
        let viewController = AddWordViewController(categoryID: categoryID)

        let interactor = AddWordInteractor(service: AddWordService())
        interactor.view = viewController

        viewController.output = interactor

        return viewController
    }
}
