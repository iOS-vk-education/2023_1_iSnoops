//
//  ProfileService.swift
//  easyLanguage
//
//  Created by Grigoriy on 27.12.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol ProfileServiceProtocol {
//    func uploadProfileImage(with imageLink: String?, completion: @escaping (Result<URL, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {

    static let shared: ProfileServiceProtocol = ProfileService()

    private let dataBase = Firestore.firestore()

    func loadProfile(completion: @escaping (Result<ProfileApiModel, Error>) -> Void) {

    }

//    func uploadProfileImage(with imageLink: String?, completion: @escaping (Result<URL, Error>) -> Void) {
//        guard let imageLink = imageLink,
//              let imageUrl = URL(string: imageLink)
//        else {
//            return
//        }
//
//        imageManager.loadImage(from: imageUrl) { result in
//            switch result {
//            case .success(let imageData):
//                let imageRef = Storage.storage().reference().child("users/\(UUID().uuidString)")
//
//                let metadata = StorageMetadata()
//                metadata.contentType = "image/png"
//
//                imageRef.putData(imageData, metadata: metadata) { [weak self] _, error in
//                    if let error = error {
//                        completion(.failure(error))
//                        return
//                    }
//
//                    imageRef.downloadURL { url, error in
//                        if let url {
//                            completion(.success(url))
//                        } else if let error = error {
//                            completion(.failure(error))
//                        }
//                    }
//                    self?.downloadURL(from: imageRef, completion: completion)
//                }
//            case .failure(let error):
//                completion(.failure(error))
//                return
//            }
//        }
//    }
//
//    private func downloadURL(from imageRef: StorageReference, completion: @escaping (Result<URL, Error>) -> Void) {
//        imageRef.downloadURL { url, error in
//            if let url = url {
//                completion(.success(url))
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }
//    }
}
