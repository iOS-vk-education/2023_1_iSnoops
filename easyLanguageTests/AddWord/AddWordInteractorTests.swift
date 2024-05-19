//
//  .swift
//  easyLanguageTests
//
//  Created by Grigoriy on 17.05.2024.
//

import XCTest
@testable import easyLanguage

final class AddWordInteractorTests: XCTestCase {

    private var addWordService: Mocks.AddWordServiceMock!
    private var mockView: Mocks.AddWordViewMock!
    private var interactor: AddWordInteractor!

    override func setUp() {
        super.setUp()
        addWordService = Mocks.AddWordServiceMock()
        mockView = Mocks.AddWordViewMock()
        interactor = AddWordInteractor(service: addWordService)
        interactor.view = mockView
    }

    override func tearDown() {
        interactor = nil
        mockView = nil
        addWordService = nil
        super.tearDown()
    }

    // MARK: - Test Cases

    func testAddWordInteractor_ViewLoaded() {
        // When
        interactor.handle(event: .viewLoaded)

        // Then
        XCTAssertTrue(mockView.handleCalled)
    }

    func testAddWordInteractor_AddButtonTapped() {
        // Given
        let uiModel = WordUIModel(
            categoryId: UUID().uuidString,
            translations: ["ru": "яблоко", "en": "apple"],
            isLearned: false,
            swipesCounter: 0,
            id: UUID().uuidString
        )

        // When
        interactor.handle(
            event: .addButtonTapped(
                uiModel: uiModel)
        )

        // Then
        XCTAssertTrue(addWordService.addCalled)
        XCTAssertTrue(mockView.handleCalled)
    }

    func testAddWordInteractor_AddButtonTapped_InvalidInput() {
        // Given
        let uiModel = WordUIModel(
            categoryId: UUID().uuidString,
            translations: ["ru": "", "en": ""],
            isLearned: false,
            swipesCounter: 0,
            id: UUID().uuidString
        )

        // When
        interactor.handle(event: .addButtonTapped(uiModel: uiModel))

        // Then
        XCTAssertFalse(addWordService.addCalled)
        XCTAssertTrue(mockView.handleCalled)
    }

    func testAddWordInteractor_TranslateButtonTapped_NativeWord() {
        // Given
        let nativeWord = "яблоко"
        let foreignWord = ""

        // When
        interactor.handle(event: .translateButtonTapped(native: nativeWord, foreign: foreignWord))

        // Then
        XCTAssertTrue(addWordService.translateCalled)
        XCTAssertTrue(mockView.handleCalled)
    }

    func testAddWordInteractor_TranslateButtonTapped_ForeignWord() {
        // Given
        let nativeWord = ""
        let foreignWord = "apple"

        // When
        interactor.handle(event: .translateButtonTapped(native: nativeWord, foreign: foreignWord))

        // Then
        XCTAssertTrue(addWordService.translateCalled)
        XCTAssertTrue(mockView.handleCalled)
    }

    func testAddWordInteractor_CheckIsValid_ValidData() {
        // Given
        let wordType = WordType("яблоко", native: true)

        // When
        interactor.handle(event: .checkIsValid(wordType))

        // Then
        XCTAssertFalse(mockView.handleCalled)
    }

    func testAddWordInteractor_CheckIsValid_InvalidData() {
        // Given
        let wordType = WordType("", native: true)

        // When
        interactor.handle(event: .checkIsValid(wordType))

        // Then
        XCTAssertTrue(mockView.handleCalled)
    }
}
