//
//  CatalogModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation

final class CatalogModel {
    private let topFiveService = TopFiveService.shared
    private let categoryService = CategoryService.shared

    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsModel], Error>) -> Void) {
        topFiveService.loadTopFiveWords { result in
            switch result {
            case .success(let topFiveData):
                let topFiveWords = topFiveData.map { word in
                    TopFiveWordsModel(translations: word.translations)
                }
                completion(.success(topFiveWords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadProgressView(completion: @escaping (Result<(Int, Int), Error>) -> Void) {
        Task {
            do {
                let counts = try await self.categoryService.loadProgressView()
                await MainActor.run {
                    completion(.success(counts))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
