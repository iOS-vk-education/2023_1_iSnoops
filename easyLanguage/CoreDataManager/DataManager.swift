//
//  DataManager.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 30.04.2024.
//

import Foundation
import CoreData

protocol DataManagerDescription {
    func initCoreData(completion: @escaping () -> Void)
    func fetch<T>(with request: NSFetchRequest<T>) -> [T]
    func create<T: NSManagedObject>(with entityName: String,
                                  configurationBlock: @escaping (T) -> Void)
}

final class DataManager {

    private let modelWord = "WordCoreDataModel"
    private let container: NSPersistentContainer

    var mainQueueContext: NSManagedObjectContext {
        return container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: modelWord)
    }

    static let shared: DataManagerDescription = DataManager()
}

// MARK: - DataManagerDescription
extension DataManager: DataManagerDescription {
    func initCoreData(completion: @escaping () -> Void) {
        container.loadPersistentStores { description, error in
            if let error {
                //FIXME: - добавить alert
                print("[DEBUG]: initCoreData error with \(error.localizedDescription)")
                return
            }
            print("[DEBUG]: ok")
            completion()
        }
    }

    func fetch<T>(with request: NSFetchRequest<T>) -> [T] where T: NSFetchRequestResult {
        return (try? mainQueueContext.fetch(request)) ?? []
    }

    func create<T>(with entityName: String,
                   configurationBlock: @escaping (T) -> Void) where T: NSManagedObject {
        mainQueueContext.performAndWait {
            guard let newObject = NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                                    into: self.mainQueueContext) as? T else {
                return
            }
            try? mainQueueContext.save()
            configurationBlock(newObject)
        }
    }
}
