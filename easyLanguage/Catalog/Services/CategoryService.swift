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
    func postCategory(with category: CategoryModel, completion: @escaping (Result<Void, Error>) -> Void)
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

    // FIXME: - эти методы пойдут в AddNewCategory
    func postCategory(with category: CategoryModel, completion: @escaping (Result<Void, Error>) -> Void) {
        uploadCategoryImage(with: category.imageLink) { [weak self] result in
            guard let self else {
                return
            }

            switch result {
            case .success(let imageURL):
                let categoryDict: [String: Any] = [
                    "title": category.title,
                    "imageLink": imageURL.absoluteString,
                    "createdDate": category.createdDate,
                    "linkedWordsId": category.linkedWordsId
                ]

                self.dataBase.collection("categories").addDocument(data: categoryDict) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }

                self.addDocumentToCategoriesCollection(with: categoryDict, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func addDocumentToCategoriesCollection(with data: [String: Any],
                                                   completion: @escaping (Result<Void, Error>) -> Void) {
        dataBase.collection("categories").addDocument(data: data) { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func uploadCategoryImage(with imageLink: String?, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageLink = imageLink,
              let imageUrl = URL(string: imageLink)
        else {
            return
        }

        imageManager.loadImage(from: imageUrl) { result in
            switch result {
            case .success(let imageData):
                let imageRef = Storage.storage().reference().child("categories/\(UUID().uuidString)")

                let metadata = StorageMetadata()
                metadata.contentType = "image/png"

                imageRef.putData(imageData, metadata: metadata) { [weak self] _, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    imageRef.downloadURL { url, error in
                        if let url {
                            completion(.success(url))
                        } else if let error = error {
                            completion(.failure(error))
                        }
                    }
                    self?.downloadURL(from: imageRef, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }

    private func downloadURL(from imageRef: StorageReference, completion: @escaping (Result<URL, Error>) -> Void) {
        imageRef.downloadURL { url, error in
            if let url = url {
                completion(.success(url))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
