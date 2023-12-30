//
//  Managers.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.11.2023.
//

import Foundation

protocol ImageManagerDescription {
    func loadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ImageManager: ImageManagerDescription {

    static let shared = ImageManager()
    private init() {}

    private let networkImageQueue = DispatchQueue(label: "networkImageQueue", attributes: .concurrent)

    func loadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let mainThreadCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }

        networkImageQueue.async {
            do {
                let imageData = try Data(contentsOf: url)
                mainThreadCompletion(.success(imageData))
            } catch {
                mainThreadCompletion(.failure(error))
            }
        }
    }
}
