//
//  CoreDataWord.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 13.05.2024.
//

import Foundation
import CoreData

class CoreDataWord {
    let persistentContainer = NSPersistentContainer(name: "CdModel")
    lazy var fetchedResultsController: NSFetchedResultsController<WordCDModel> = {
        let request = WordCDModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(WordCDModel.isLearned), ascending: true)
        request.sortDescriptors = [sortDescriptor]

        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: self.persistentContainer.viewContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
//        frc.delegate = self
        return frc
    }()
    
    func loadStore() {
        persistentContainer.loadPersistentStores { (persistentStoreDescriptor, error) in
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
