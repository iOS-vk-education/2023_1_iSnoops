//
//  AddNewWordInteractor.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.04.2024.
//

import Foundation

@MainActor protocol AddNewWordInteractorOutput {
    func handle(event: AddNewWordInteractorEvent)
}

final class AddNewWordInteractor {

    var presenter: AddNewWordInteractorOutput?

    private let addNewWordService: AddNewWordServiceProtocol?
//FIXME: - такие вещи (передаются в параметрах функциях) убрать или потом они нужны для тестов?
    private var word: String?
    private var isNative: Bool?
    private var wordUIModel: WordUIModel?

    init(
        addNewWordService: AddNewWordServiceProtocol,
        word: String? = nil,
        isNative: Bool? = nil,
        wordUIModel: WordUIModel? = nil
    ) {
        self.addNewWordService = addNewWordService
        self.word = word
        self.isNative = isNative
        self.wordUIModel = wordUIModel
    }
}

extension AddNewWordInteractor: AddNewWordViewOutput {
    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    @MainActor func handle(event: AddNewWordViewEvent) {
        switch event {
        case .viewLoaded:
            presenter?.handle(event: .viewLoaded)

        case let .translateButtonTapped(word, isNative):
            self.word = word
            self.isNative = isNative

            translate(with: word, isNative: isNative) { [weak self] result in
                switch result {
                case .success(let translation):
                    guard let translation else {
                        DispatchQueue.main.async {
                            self?.presenter?.handle(event: .showAlert(message: "Не удалось найти перевод"))
                        }
                        return
                    }
                    if isNative {
                        DispatchQueue.main.async {
                            self?.presenter?.handle(event: .addForeignTranslate(text: translation))
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.presenter?.handle(event: .addNativeTranslate(text: translation))
                        }
                    }

                case .failure(let error):
                    print("[DEBUG]: ", #function, #line, error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.presenter?.handle(event: .showAlert(message: "Ошибка добавления перевода"))
                    }
                }
            }

        case let .addNewCardTapped(wordUIModel):
            self.wordUIModel = wordUIModel

            addNewWord(with: wordUIModel) { [weak self] result in
                switch result {
                case .success:
                    guard let wordUIModel = self?.wordUIModel else {
                        print("[DEBUG]: ", #function, #line, "self?.wordUIModel is nil")
                        DispatchQueue.main.async {
                            self?.presenter?.handle(event: .showAlert(message: "Ошибка добавлнея слова"))
                        }
                        return
                    }

                    self?.presenter?.handle(event: .addNewWord(id: wordUIModel.categoryId))
                case .failure(let error):
                    print("[DEBUG]: ", #function, #line, error.localizedDescription)
                    DispatchQueue.main.async {
                        self?.presenter?.handle(event: .showAlert(message: "ошибка добавления слова"))
                    }
                }
            }
        case let .translateCheckIsOptionText(native, foreign):
            guard native != nil || foreign != nil else {
                self.presenter?.handle(event: .showAlert(message: "Необходимо ввести слово"))
                return
            }
        case .checkIsValidNativeText(text: let text, isNative: let isNative):
            guard let text = text, !text.isEmpty else {
                if isNative {
                    self.presenter?.handle(event: .showAlert(message: "Необходимо ввести слово на русском"))
                } else {
                    self.presenter?.handle(event: .showAlert(message: "Необходимо ввести перевод слова"))
                }
                return
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
    // swiftlint:enable function_body_length
}

private extension AddNewWordInteractor {
    func translate(
        with word: String,
        isNative: Bool,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        addNewWordService?.apiTranslation(with: word, isNative: isNative, completion: completion)
    }

    func addNewWord(with model: WordUIModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let wordAPIModel = WordApiModel(categoryId: model.categoryId,
                                        translations: model.translations,
                                        isLearned: model.isLearned,
                                        id: model.id)
        addNewWordService?.addNewWord(with: wordAPIModel, completion: completion)
    }
}
