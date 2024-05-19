//
//  CategoryDetailModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import Foundation
import CoreData

final class CategoryDetailModel {

    private let categoryService = CategoryDetailService.shared
    private let coreData = CoreDataService()

    func loadCDWords(with linkedWordsId: String) -> [WordUIModel] {
        let moc = coreData.persistentContainer.viewContext
        let wordsFetch = NSFetchRequest<WordCDModel>(entityName: .wordCDModel)
        wordsFetch.predicate = NSPredicate(format: "categoryId == %@", linkedWordsId)

        guard let words = try? moc.fetch(wordsFetch) else {
            return []
        }

        let wordsModel = words.map { word in
            WordUIModel(
                categoryId: word.categoryId ?? "",
                translations: word.translations ?? [:],
                isLearned: word.isLearned,
                swipesCounter: Int(word.swipesCounter),
                id: word.id ?? ""
            )
        }

        return wordsModel
    }

    func deleteCDWord(with id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let error = try? coreData.deleteWord(with: id) {
            completion(.failure(error))
        } else {
            completion(.success(true))
        }
    }

    func reloadCDIsLearned(with id: String, isLearned: Bool, swipesCounter: Int) {
        coreData.reloadIsLearned(with: id, isLearned: isLearned, swipesCounter: swipesCounter)
    }

    func loadWords(with linkedWordsId: String, completion: @escaping (Result<[WordUIModel], Error>) -> Void) {
        categoryService.loadWords(with: linkedWordsId) { result in
            switch result {
            case .success(let wordsApiModel):
                let wordsModel = wordsApiModel.map { word in
                    WordUIModel(categoryId: word.categoryId,
                                translations: word.translations,
                                isLearned: word.isLearned,
                                swipesCounter: word.swipesCounter,
                                id: word.id)
                }
                completion(.success(wordsModel))
            case .failure(let error):
                print("[DEBUG]: \(#function), \(error.localizedDescription)")
            }
        }
    }

    func reloadIsLearned(with id: String, isLearned: Bool, swipesCounter: Int) {
        categoryService.reloadIsLearned(with: id, isLearned: isLearned, swipesCounter: swipesCounter)
    }

    func deleteWord(with id: String, comletion: @escaping (Result<Bool, Error>) -> Void) {
        categoryService.deleteWord(with: id) { result in
            comletion(result)
        }
    }
}
