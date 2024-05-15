//
//  CoreDataService.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 13.05.2024.
//

import Foundation
import CoreData

class CoreDataService {
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

    func loadStore() {
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

    func saveWordToCoreData(model: WordApiModel) {
        let wordToCoreData = WordCDModel.init(entity: NSEntityDescription.entity(forEntityName: "WordCDModel",
                                                                                 in: persistentContainer.viewContext)!,
                                              insertInto: persistentContainer.viewContext)
        wordToCoreData.id = model.id
        wordToCoreData.categoryId = model.categoryId
        wordToCoreData.isLearned = model.isLearned
        wordToCoreData.swipesCounter = Int64(model.swipesCounter)
        wordToCoreData.translations = model.translations

        try? wordToCoreData.managedObjectContext?.save()
    }
}
