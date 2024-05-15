//
//  AddWordInteractor.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.04.2024.
//

import Foundation

final class AddWordInteractor {
    weak var view: AddWordViewInput?

    private let service: AddWordServiceProtocol

    init(service: AddWordServiceProtocol) {
        self.service = service
    }
}

// MARK: - AddWordViewOutput

extension AddWordInteractor: AddWordViewOutput {
    func handle(event: AddWordViewOutputEvent) {
        guard let view = self.view else { return }
        switch event {
        case .viewLoaded:
            view.handle(event: .showView)

        case let .addButtonTapped(uiModel: model):
            if let errorMessage = validate(inputed: model.translations) {
                view.handle(event: .showAlert(message: errorMessage))
                return
            }
            add(word: WordApiModel(ui: model))

        case let .translateButtonTapped(nativeWord, foreignWord):
            translate(!nativeWord.isEmpty ? WordType(nativeWord, native: true) : WordType(foreignWord, native: false))

        case .checkIsValid(let wordType):
            if let message = validate(data: wordType) {
                view.handle(event: .showAlert(message: message))
            }
        }
    }
}

// MARK: - validate word

private extension AddWordInteractor {
    func validate(data: WordType) -> String? {
        validate(inputed: data.native ? ["ru": data.word] : ["en": data.word])
    }

    func validate(inputed: [String: String]) -> String? {
        if let nativeText = inputed["ru"], nativeText.isEmpty {
            return "Необходимо ввести слово на русском"
        }

        if let foreignText = inputed["en"], foreignText.isEmpty {
            return "Необходимо ввести перевод слова"
        }

        return nil
    }
}

// MARK: - add word

private extension AddWordInteractor {
    func add(word: WordApiModel) {
        service.add(word) { [weak self] result in
            Task {
                guard let self = self, let view = self.view else {
                    await MainActor.run { self?.view?.handle(event: .showAlert(message: "Ошибка добавления слова")) }
                    return
                }
                switch result {
                case .success:
                    await MainActor.run { view.handle(event: .updateCategoryDetail(id: word.categoryId)) }
                case .failure:
                    await MainActor.run { view.handle(event: .showAlert(message: "Ошибка добавления слова")) }
                }
            }
        }
    }
}

// MARK: - translate word

private extension AddWordInteractor {
    func translate(_ data: WordType) {
        service.translate(data) { [weak self] result in
            Task {
                guard let self = self, let view = self.view else {
                    return await MainActor.run {
                        self?.view?.handle(event: .showAlert(message: "Не удалось найти перевод"))
                    }
                }
                switch result {
                case .success(let translationWord):
                    guard let translationWord = translationWord else {
                        return await MainActor.run {
                            view.handle(event: .showAlert(message: "Не удалось найти перевод"))
                        }
                    }
                    await MainActor.run { view.handle(event: .updateField((translationWord, data.native))) }
                case .failure(let error):
                    print("[DEBUG]: ", #function, #line, error.localizedDescription)
                    await MainActor.run { view.handle(event: .showAlert(message: "Ошибка добавления перевода")) }
                }
            }
        }
    }
}
