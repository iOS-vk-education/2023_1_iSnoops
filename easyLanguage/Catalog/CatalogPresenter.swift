//
//  CatalogPresenter.swift
//  easyLanguage
//
//  Created by Grigoriy on 23.12.2023.
//

import Foundation

final class CatalogPresenter {
    private let model = CatalogModel()
    weak var view: CatalogViewInput?
}

extension CatalogPresenter: CatalogViewOutput {
    func didLoadView() {
        guard let view else {
            return
        }

        model.loadTopFiveWords { result in
            switch result {
            case .success(let data):
                view.configureTopFiveWords(with: data)
            case .failure(let error):
                view.showError(with: error.localizedDescription)
            }
        }

        // FIXME: - сходить реально в сеть через model
        view.setupAllLearnedWords(with: 120)
        view.setupWordsInProgress(with: 43)
        view.setProgress()
    }
}
