//
//  AddWordService.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol AddWordServiceProtocol {
    func add(_ model: WordApiModel, completion: @MainActor @escaping (Result<Void, Error>) -> Void)
    func translate(_ data: WordType, completion: @MainActor @escaping (Result<String?, Error>) -> Void)
}

final class AddWordService: AddWordServiceProtocol {

    static let shared: AddWordServiceProtocol = AddWordService()
    private let dataBase = Firestore.firestore()
    private let coreData = CoreDataService()

    func add(_ model: WordApiModel, completion: @MainActor @escaping (Result<Void, Error>) -> Void) {
        coreData.loadStore()
        coreData.saveWordToCoreData(model: model)
        dataBase.collection("words").document(model.id).setData([
            "categoryId": model.categoryId,
            "translations": model.translations,
            "isLearned": model.isLearned,
            "id": model.id
        ]) { error in
            Task {
                if let error = error {
                    await MainActor.run { completion(.failure((error))) }
                } else {
                    await MainActor.run { completion(.success(())) }
                }
            }
        }
    }

    func translate(_ data: WordType, completion: @MainActor @escaping (Result<String?, Error>) -> Void) {
        // swiftlint:disable:next line_length
        let baseURL = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20231020T102336Z.112d6c2d71376dac.b70bd489b5bd6157f8ca6baec7b50467cd0f4593&lang="

        let path = baseURL + (data.native ? "ru-en" : "en-ru")

        guard let url = URL(string: path + "&text=" + data.word) else {
            Task { await MainActor.run { completion(.failure(NetworkError.unexpectedURL)) } }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            Task {
                if let error {
                    await MainActor.run { completion(.failure(error)) }
                }

                guard let data else {
                    return await MainActor.run { completion(.failure(NetworkError.emptyData)) }
                }

                do {
                    let decoder = JSONDecoder()
                    let translationResponse = try decoder.decode(TranslationResponse.self, from: data)
                    await MainActor.run {
                        completion(.success(translationResponse.definitions?.first?.translations?.first?.text))
                    }
                } catch {
                    await MainActor.run { completion(.failure(error)) }
                }
            }
        }.resume()
    }
}
