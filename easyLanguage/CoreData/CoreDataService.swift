//
//  CoreDataService.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 13.05.2024.
//

import UIKit
import CoreData

final class CoreDataService {
    init() {
        loadStore()
    }

    let persistentContainer = NSPersistentContainer(name: "CdModel")
    lazy var fetchedResultsController: NSFetchedResultsController<WordCDModel> = {
        let request = WordCDModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(WordCDModel.isLearned), ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return  NSFetchedResultsController(fetchRequest: request,
                                           managedObjectContext: self.persistentContainer.viewContext,
                                           sectionNameKeyPath: nil,
                                           cacheName: nil)
    }()

    private func loadStore() {
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("unable to load")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    print(error)
                }
            }
        }
    }
}

// MARK: - Methods

extension CoreDataService {
    func saveWordToCoreData(model: WordApiModel) {
        let wordToCoreData = WordCDModel.init(entity: NSEntityDescription.entity(forEntityName: .wordCDModel,
                                                                                 in: persistentContainer.viewContext)!,
                                              insertInto: persistentContainer.viewContext)
        wordToCoreData.id = model.id
        wordToCoreData.categoryId = model.categoryId
        wordToCoreData.isLearned = model.isLearned
        wordToCoreData.swipesCounter = Int64(model.swipesCounter)
        wordToCoreData.translations = model.translations

        try? wordToCoreData.managedObjectContext?.save()
    }

    func saveCategory(with category: CategoryModel, imageData: Data?) {
        let categoryToCoreData = CategoryCDModel.init(
            entity: NSEntityDescription.entity(forEntityName: .categoryCDModel,
                                               in: persistentContainer.viewContext)!,
            insertInto: persistentContainer.viewContext
        )

        categoryToCoreData.createdDate = category.createdDate
        categoryToCoreData.index = Int64(category.index ?? 0)
        categoryToCoreData.linkedWordsId = category.linkedWordsId
        categoryToCoreData.studiedWordsCount = Int64(category.studiedWordsCount)
        categoryToCoreData.totalWordsCount = Int64(category.totalWordsCount)
        categoryToCoreData.title = category.title
        categoryToCoreData.imageData = imageData

        try? categoryToCoreData.managedObjectContext?.save()
    }

    func deleteCategory(with id: String) throws -> Error? {
        let fetchRequest: NSFetchRequest<CategoryCDModel> = CategoryCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "linkedWordsId == %@", id)

        do {
            let categories = try persistentContainer.viewContext.fetch(fetchRequest)
            for category in categories {
                deleteWords(for: category)  // Удаление всех слов, связанных с этой категорией
                persistentContainer.viewContext.delete(category)
            }

            try persistentContainer.viewContext.save()
            return nil
        } catch {
            return error
        }
    }

    func loadWordsCounts(with linkedWordsId: String) -> (Int, Int) {
        let fetchRequest: NSFetchRequest<WordCDModel> = WordCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@", linkedWordsId)

        do {
            let words = try persistentContainer.viewContext.fetch(fetchRequest)
            let totalWordsCount = words.count
            let studiedWordsCount = words.filter { $0.isLearned }.count
            return (totalWordsCount, studiedWordsCount)
        } catch {
            print("loadWordsCounts error \(error)")
            return (0, 0)
        }
    }

    // Удаление всех слов, связанных с этой категорией
    private func deleteWords(for category: CategoryCDModel) {
        let fetchRequest: NSFetchRequest<WordCDModel> = WordCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryId == %@", category.linkedWordsId ?? "")

        do {
            let words = try persistentContainer.viewContext.fetch(fetchRequest)
            for word in words {
                persistentContainer.viewContext.delete(word)
            }
        } catch {
            print("deleteWords error \(error)")
        }
    }
}
