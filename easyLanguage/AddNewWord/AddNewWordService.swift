//
//  AddNewWordService.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol AddNewWordServiceProtocol {
    func addNewWord(with model: WordApiModel, completion: @escaping (Result<Void, Error>) -> Void)
    func apiTranslation(with word: String, completion: @escaping (Result<String?, Error>) -> Void)
}

final class AddNewWordService: AddNewWordServiceProtocol {

    static let shared: AddNewWordServiceProtocol = AddNewWordService()
    private let dataBase = Firestore.firestore()

    func addNewWord(with model: WordApiModel, completion: @escaping (Result<Void, Error>) -> Void) {
        dataBase.collection("words").document(model.id).setData([
            "categoryId": model.categoryId,
            "translations": model.translations,
            "isLearned": model.isLearned,
            "id": model.id
        ]) { error in
            if let error = error {
                completion(.failure((error)))
            } else {
                completion(.success(()))
            }
        }
    }

    func apiTranslation(with word: String, completion: @escaping (Result<String?, Error>) -> Void) {
        // swiftlint:disable:next line_length
        guard let url = URL(string: "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=dict.1.1.20231020T102336Z.112d6c2d71376dac.b70bd489b5bd6157f8ca6baec7b50467cd0f4593&lang=ru-en&text=\(word)") else {
            completion(.failure(NetworkError.unexpectedURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(error))
                return
            }

            guard let data else {
                completion(.failure(NetworkError.emptyData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let translationResponse = try decoder.decode(TranslationResponse.self, from: data)

                completion(.success(translationResponse.def?.first?.tr?.first?.text))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
