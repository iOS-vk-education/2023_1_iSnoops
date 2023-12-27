//
//  TopFiveService.swift
//  easyLanguage
//
//  Created by Grigoriy on 03.12.2023.
//

import Foundation

protocol TopFiveServiceProtocol {
    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
}

final class TopFiveService: TopFiveServiceProtocol {

    static let shared: TopFiveServiceProtocol = TopFiveService()

    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        completion(.success(MockData.topFiveWords))
    }
}
