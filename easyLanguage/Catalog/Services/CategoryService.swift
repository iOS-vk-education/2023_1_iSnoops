//
//  CategoryService.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol CatalogNetworkManagerProtocol {
    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void)
    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void)
}

final class CatalogNetworkManager: CatalogNetworkManagerProtocol {

    static let shared: CatalogNetworkManagerProtocol = CatalogNetworkManager()
    private init() {}

    private let imageManager = ImageManager.shared
    private let dataBase = Firestore.firestore()

    func getTopFiveWords(completion: @escaping (Result<[TopFiveWordsApiModel], Error>) -> Void) {
        completion(.success(MockData.topFiveWords))
    }

    func getCategories(completion: @escaping (Result<[CategoryApiModel], Error>) -> Void) {
        dataBase.collection("categories").getDocuments { querySnapshot, error in
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents else {
                completion(.failure(NetworkError.unexpected))
                return
            }

            let categories: [CategoryApiModel] = documents.compactMap { document in
                do {
                    let category = try document.data(as: CategoryApiModel.self)
                    return category
                } catch {
                    return nil
                }
            }
            completion(.success(categories))
        }
    }
}
