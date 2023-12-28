//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol CatalogNetworkManagerProtocol {
    func loadCategories() async throws -> [CategoryApiModel]
}

final class CategoryService: CatalogNetworkManagerProtocol {

    static let shared: CatalogNetworkManagerProtocol = CategoryService()

    private let dataBase = Firestore.firestore()

    func loadCategories() async throws -> [CategoryApiModel] {
        guard let uid = checkAuthentication() else {
            print("пользователь не авторизован")
            throw AuthErrors.userNotAuthenticated
        }

        return try await withCheckedThrowingContinuation { continuation in
            dataBase.collection("categories")
                .whereField("profileId", isEqualTo: uid)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print(error)
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let documents = querySnapshot?.documents else {
                        continuation.resume(throwing: NetworkError.unexpected)
                        return
                    }

                    let categories: [CategoryApiModel] = documents.compactMap { document in
                        do {
                            let category = try document.data(as: CategoryApiModel.self)
                            return category
                        } catch {
                            continuation.resume(throwing: error)
                            return nil
                        }
                    }

                    continuation.resume(returning: categories)
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
