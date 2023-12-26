//
//  CatalogProtocols.swift
//  easyLanguage
//
//  Created by Grigoriy on 23.12.2023.
//

import Foundation

protocol CatalogViewOutput: AnyObject {
    func didLoadView()
}

protocol CatalogViewInput: AnyObject {
    func configureTopFiveWords(with data: [TopFiveWordsModel])
    func showError(with text: String)
    func setupAllLearnedWords(with count: Int)
    func setupWordsInProgress(with count: Int)
    func setProgress()
}
