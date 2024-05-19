//
//  TopFiveService.swift
//  easyLanguage
//
//  Created by Grigoriy on 03.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol TopFiveServiceProtocol {
    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
}

final class TopFiveService: TopFiveServiceProtocol {

    static let shared: TopFiveServiceProtocol = TopFiveService()

    private let dataBase = Firestore.firestore()

    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        guard let uid = checkAuthentication() else {
            completion(.failure(AuthErrors.userNotAuthenticated))
            return
        }

        dataBase.collection("topFiveWords")
                .whereField("userId", isEqualTo: uid).getDocuments { querySnapshot, error in

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

    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }
}
