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
//    func loadProfile(completion: @escaping (Result<ProfileApiModel, Error>) -> Void)
    func loadProfile() async throws -> ProfileApiModel
    func uploadImage(image: UIImage) async throws -> URL
}

final class ProfileService: ProfileServiceProtocol {

    static let shared: ProfileServiceProtocol = ProfileService()
    
    private init() {}

    private let dataBase = Firestore.firestore()

    func uploadImage(image: UIImage) async throws -> URL {
        guard let userId = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }
        let reference = Storage.storage().reference().child("users").child(userId)
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            throw NetworkError.unexpected
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            reference.putData(imageData, metadata: metadata)
            let downloadURL = try await reference.downloadURL()
            try await dataBase.collection("users").document(userId).setData(["imageLink": downloadURL.absoluteString], merge: true)
            let url = try await reference.downloadURL()
            return url
        } catch {
            print("Ошибка при загрузке изображения: \(error)")
            throw error
        }
    }
    
//    func uploadImage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let userId = checkAuthentication() else {
//            completion(.failure(AuthErrors.userNotAuthenticated))
//            return
//        }
//        let reference = Storage.storage().reference().child("users").child(userId)
//        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
//            return
//        }
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        reference.putData(imageData, metadata: metadata) { (metadata, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            reference.downloadURL { [weak self]  (url, error) in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                guard let url = url else {
//                    completion(.failure(NetworkError.unexpected))
//                    return
//                }
//                self?.dataBase.collection("users").document(userId).setData(["imageLink": url.absoluteString], merge: true)
//                completion(.success(url))
//            }
//        }
//    }
    
//    func loadProfile(completion: @escaping (Result<ProfileApiModel, Error>) -> Void) {
//            guard let userId = checkAuthentication() else {
//                completion(.failure(AuthErrors.userNotAuthenticated))
//                return
//            }
//        
//            dataBase.collection("users").document(userId).getDocument { document, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                guard let document = document, document.exists else {
//                    completion(.failure(NetworkError.unexpected))
//                    return
//                }
//                do {
//                    guard let data = document.data(),
//                          let profile = ProfileApiModel(dict: data)
//                    else {
//                        throw NetworkError.unexpected
//                    }
//                    completion(.success(profile))
//                } catch {
//                    completion(.failure(NetworkError.unexpected))
//                }
//            }
//        }

    func loadProfile() async throws -> ProfileApiModel {
        guard let userId = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }
        let document = try await dataBase.collection("users").document(userId).getDocument()
        if document.exists {
            guard let data = document.data(),
                    let profile = ProfileApiModel(dict: data)
            else {
                throw NetworkError.unexpected
            }
            return profile
        } else {
                throw NetworkError.unexpected
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
