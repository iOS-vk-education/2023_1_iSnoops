//
//  Mocks.AddWordServiceMock.swift
//  easyLanguageTests
//
//  Created by Grigoriy on 18.05.2024.
//

import Foundation
@testable import easyLanguage

extension Mocks {
    final class AddWordServiceMock: AddWordServiceProtocol {
        var addCalled = false
        var translateCalled = false

        @MainActor func add(_ model: WordApiModel,
                            completion: @MainActor @escaping (Result<Void, Error>) -> Void) {
            addCalled = true

            completion(.success(()))
        }

        @MainActor func translate(_ data: WordType,
                                  completion: @MainActor @escaping (Result<String?, Error>) -> Void) {
            if data.word.isEmpty {
                completion(.failure(NetworkError.emptyData))
            }
            translateCalled = true

            completion(.success("Translated Word"))
        }
    }
}
