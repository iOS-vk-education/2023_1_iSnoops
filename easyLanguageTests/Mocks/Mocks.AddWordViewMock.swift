//
//  Mocks.AddWordViewMock.swift
//  easyLanguageTests
//
//  Created by Grigoriy on 18.05.2024.
//

import Foundation
@testable import easyLanguage

extension Mocks {
    final class AddWordViewMock: AddWordViewInput {
        var handleCalled = false

        func handle(event: AddWordViewInputEvent) {
            handleCalled = true
        }
    }
}
