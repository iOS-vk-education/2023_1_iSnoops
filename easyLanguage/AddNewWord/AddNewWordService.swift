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
}
