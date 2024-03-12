//
//  ProfileService.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol ProfileServiceProtocol {
    func loadProfile(completion: @escaping (Result<ProfileApiModel, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {

    static let shared: ProfileServiceProtocol = ProfileService()

    private let dataBase = Firestore.firestore()

    func loadProfile(completion: @escaping (Result<ProfileApiModel, Error>) -> Void) {
            guard let userId = checkAuthentication() else {
                completion(.failure(AuthErrors.userNotAuthenticated))
                return
            }
            dataBase.collection("users").document(userId).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = document, document.exists else {
                    completion(.failure(NetworkError.unexpected))
                    return
                }
    
                do {
                    let profile = ProfileApiModel(dict: document.data()!)
                    completion(.success(profile!))
                } catch {
                    completion(.failure(NetworkError.unexpected))
                }
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
