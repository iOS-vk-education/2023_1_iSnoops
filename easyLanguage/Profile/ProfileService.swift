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
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            throw NetworkError.unexpected
        }
        let reference = Storage.storage().reference().child("users").child(userId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            let _ = try await reference.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await reference.downloadURL()
            try await dataBase.collection("users").document(userId).setData(["imageLink": downloadURL.absoluteString], merge: true)
            return downloadURL
        } catch {
            print("Ошибка при загрузке изображения: \(error)")
            throw error
        }
    }
    
    func loadProfile() async throws -> ProfileApiModel {
        guard let userId = checkAuthentication() else {
            throw AuthErrors.userNotAuthenticated
        }
        let document = try await dataBase.collection("users").document(userId).getDocument()
        if document.exists, let data = document.data(), let profile = ProfileApiModel(dict: data) {
            return profile
        }
        throw NetworkError.unexpected
    }
    
    private func checkAuthentication() -> String? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        } else {
            return nil
        }
    }
}
