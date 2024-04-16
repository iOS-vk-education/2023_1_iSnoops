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
    @MainActor func handle(event: AddNewWordViewEvent) {
        switch event {
        case .viewLoaded:
            presenter?.handle(event: .viewLoaded)

        case let .addNewCardTapped(model):
            self.wordUIModel = model

            guard let nativeText = model.translations["ru"],
                  !nativeText.isEmpty else {
                DispatchQueue.main.async {
                    self.presenter?.handle(event: .showAlert(message: "Необходимо ввести слово на русском"))
                }
                return
            }

            guard let foreignText = model.translations["en"],
                  !foreignText.isEmpty else {
                DispatchQueue.main.async {
                    self.presenter?.handle(event: .showAlert(message: "Необходимо ввести перевод слова"))
                }
                return
            }

            let translations: [String: String] = ["ru": nativeText, "en": foreignText]

            handleAddNewWord(model: WordUIModel(categoryId: model.categoryId,
                                                translations: translations,
                                                isLearned: model.isLearned,
                                                id: model.id))

        case let .translateButtonTapped(native, foreign):
            let search: String
            let isNative: Bool

            if native != nil && !native!.isEmpty {
                search = native!
                isNative = true
            } else {
                search = foreign!
                isNative = false
            }

            handleTranslationResult(word: search, isNative: isNative)

        case .checkIsValidNativeText(text: let text, isNative: let isNative):
            guard let text = text, !text.isEmpty else {

                let event: AddNewWordInteractorEvent = isNative
                ? .showAlert(message: "Необходимо ввести слово на русском")
                : .showAlert(message: "Необходимо ввести перевод слова")
                presenter?.handle(event: event)

                return
            }
        }
    }
}

private extension AddNewWordInteractor {
    func handleTranslationResult(word: String, isNative: Bool) {
        self.word = word
        self.isNative = isNative

        translate(with: word, isNative: isNative) { [weak self] result in
            switch result {
            case .success(let translation):
                DispatchQueue.main.async {
                    guard let self = self,
                          let presenter = self.presenter,
                          let translation else {
                        self?.presenter?.handle(event: .showAlert(message: "Не удалось найти перевод"))
                        return
                    }

                    let event: AddNewWordInteractorEvent = .addTranslate(text: translation, isNative: isNative)

                    presenter.handle(event: event)
                }
            case .failure(let error):
                print("[DEBUG]: ", #function, #line, error.localizedDescription)
                DispatchQueue.main.async {
                    self?.presenter?.handle(event: .showAlert(message: "Ошибка добавления перевода"))
                }
            }
        }
    }

    func handleAddNewWord(model: WordUIModel) {
        addNewWord(with: WordUIModel(categoryId: model.categoryId,
                                     translations: model.translations,
                                     isLearned: model.isLearned,
                                     id: model.id)) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    guard let self = self,
                          let presenter = self.presenter,
                          let wordUIModel = self.wordUIModel else {
                        print("[DEBUG]: ", #function, #line, "self?.wordUIModel is nil")
                        self?.presenter?.handle(event: .showAlert(message: "Ошибка добавления слова"))
                        return
                    }
                    presenter.handle(event: .addNewWord(id: wordUIModel.categoryId))
                }
            case .failure(let error):
                print("[DEBUG]: ", #function, #line, error.localizedDescription)
                DispatchQueue.main.async {
                    self?.presenter?.handle(event: .showAlert(message: "ошибка добавления слова"))
                }
            }
        }
    }
}

private extension AddNewWordInteractor {
    func translate(
        with word: String,
        isNative: Bool,
        completion: @escaping (Result<String?, Error>) -> Void
    ) {
        guard let addNewWordService else {
            completion(.failure(NetworkError.unexpected))
            return
        }

        addNewWordService.apiTranslation(with: word, isNative: isNative, completion: completion)
    }

    func addNewWord(with model: WordUIModel, completion: @escaping (Result<Void, Error>) -> Void) {
        let wordAPIModel = WordApiModel(categoryId: model.categoryId,
                                        translations: model.translations,
                                        isLearned: model.isLearned,
                                        id: model.id)
        guard let addNewWordService else {
            completion(.failure(NetworkError.unexpected))
            return
        }

        addNewWordService.addNewWord(with: wordAPIModel, completion: completion)
    }
}
