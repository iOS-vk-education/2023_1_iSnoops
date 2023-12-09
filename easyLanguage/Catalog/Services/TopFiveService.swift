//
//  TopFiveService.swift
//  easyLanguage
//
//  Created by Grigoriy on 03.12.2023.
//

import Foundation

protocol TopFiveNetworkManagerProtocol {
    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
}

final class TopFiveNetworkManager: TopFiveNetworkManagerProtocol {

    static let shared = TopFiveNetworkManager()
    private init() {}

    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        completion(.success(MockData.topFiveWords))
    }
}
