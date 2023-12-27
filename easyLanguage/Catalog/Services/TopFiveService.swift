//
//  TopFiveService.swift
//  easyLanguage
//
//  Created by Grigoriy on 03.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol TopFiveServiceProtocol {
    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
}

final class TopFiveService: TopFiveServiceProtocol {

    static let shared: TopFiveServiceProtocol = TopFiveService()

    private let dataBase = Firestore.firestore()

    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        dataBase.collection("topFiveWords").getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents else {
                completion(.failure(NetworkError.unexpected))
                return
            }

            let topFiveWords: [TopFiveWordsApiModel] = documents.compactMap { document in
                do {
                    let word = try document.data(as: TopFiveWordsApiModel.self)
                    return word
                } catch {
                    completion(.failure(error))
                    return nil
                }
            }
            completion(.success(topFiveWords))
        }
    }
}
