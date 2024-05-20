//
//  CatalogModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import Foundation
import CoreData

final class CatalogModel {
    private let topFiveService = TopFiveService.shared
    private let categoryService = CategoryService.shared

    private let coreData = CoreDataService()

    func loadTopFiveWords(completion: @escaping (Result<[TopFiveWordsModel], Error>) -> Void) {
        topFiveService.loadTopFiveWords { result in
            switch result {
            case .success(let topFiveData):
                let topFiveWords = topFiveData.map { word in
                    TopFiveWordsModel(translate: word.translate,
                                      userId: word.userId,
                                      id: word.id,
                                      date: word.date)
                }
                completion(.success(topFiveWords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func loadCDProgressView() -> (Int, Int) {
         do {
             let categories = coreData.fetchCategories()
             var totalWords = 0
             var learnedWords = 0

             for category in categories {
                 let (total, learned) = coreData.loadWordsCounts(with: category.linkedWordsId ?? "")

                 totalWords += total
                 learnedWords += learned
             }

             return (totalWords, learnedWords)
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
