//
//  CategoryDetailService.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol CategoryDetailServiceProtocol {
    func loadWords(with categoryId: String, comletion: @escaping (Result<[WordApiModel], Error>) -> Void)
    func reloadIsLearned(with id: String, isLearned: Bool)
}

final class CategoryDetailService: CategoryDetailServiceProtocol {
    static let shared: CategoryDetailServiceProtocol = CategoryDetailService()
    private let dataBase = Firestore.firestore()

    func loadWords(with categoryId: String, comletion: @escaping (Result<[WordApiModel], Error>) -> Void) {
        dataBase.collection("words").whereField("categoryId",
                                    isEqualTo: categoryId).getDocuments { querySnapshot, error in
            if let error = error {
                comletion(.failure(error))
            }
            guard let documents = querySnapshot?.documents else {
                comletion(.failure(NetworkError.unexpected))
                return
            }

            let words: [WordApiModel] = documents.compactMap { document in
                do {
                    let word = try document.data(as: WordApiModel.self)
                    return word
                } catch {
                    return nil
                }
            }

            comletion(.success(words))
        }
    }

    func reloadIsLearned(with id: String, isLearned: Bool) {
        dataBase.collection("words").document(id).updateData(["isLearned": isLearned]) { error in
            if let error = error {
                print(error)
            }
        }
    }
}
