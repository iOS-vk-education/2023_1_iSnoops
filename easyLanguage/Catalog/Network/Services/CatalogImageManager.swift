//
//  CatalogImageManager.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.11.2023.
//

import UIKit

enum ImageManagerErrors: Error {
    case unexpectedError
}

protocol CatalogImageManagerDescription {
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class CatalogImageManager: CatalogImageManagerDescription {

    static let shared = CatalogImageManager()
    private init() {}

    private let networkImageQueue = DispatchQueue(label: "networkImageQueue", attributes: .concurrent)

    func loadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let mainTreadCompletion: ((Result<UIImage, Error>) -> Void) = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        networkImageQueue.async {
            guard let imageData = try? Data(contentsOf: url),
                  let image = UIImage(data: imageData) else {
                mainTreadCompletion(.failure(ImageManagerErrors.unexpectedError))
                return
            }
            mainTreadCompletion(.success(image))
        }
    }
}
