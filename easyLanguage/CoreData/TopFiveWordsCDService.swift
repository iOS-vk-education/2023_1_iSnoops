//
//  TopFiveWordsCDService.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 15.05.2024.
//

import Foundation
import CoreData

class TopFiveWordsCDService {
    init () {
        loadStore()
    }
    let persistentContainer = NSPersistentContainer(name: "CdModel")

    var isUpdated: Bool = false {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(.topFiveWordsReadyForReading), object: nil)
        }
    }

    lazy var fetchedResultsController: NSFetchedResultsController<TopFiveWordsCDModel> = {
        let request = TopFiveWordsCDModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(TopFiveWordsCDModel.date), ascending: true)
        request.sortDescriptors = [sortDescriptor]

        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: self.persistentContainer.viewContext,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
    }()

    func saveWordsToCoreData(words: [WordUIModel], userId: String) {
        if words.count >= 5 {
            let lastFiveElements = Array(words.suffix(5))
            updateWordsInCoreData(words: lastFiveElements, userId: userId)
        } else if words.count > 0 {
            let newWords = mergeWordsToFive(words: words)
            updateWordsInCoreData(words: newWords, userId: userId)
        }
        isUpdated.toggle()
    }

    func readWordsFromCoreData() -> [TopFiveWordsCDModel] {
        let moc = self.persistentContainer.viewContext
        let wordsfetch = NSFetchRequest<TopFiveWordsCDModel>(entityName: .topFiveWordsCDModel)
        guard let coreModel = try? moc.fetch(wordsfetch) else { return [] }
        return coreModel
    }

    func deleteWordsFromCoreData() {
        let words = readWordsFromCoreData()
        let wordsCopy = Array(words)
        wordsCopy.forEach { word in
            self.fetchedResultsController.managedObjectContext.delete(word)
        }
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("ERROR CD", error)
        }
    }

    func checkWords() {
        readWordsFromCoreData().forEach { word in
            print(word.translate)
        }
    }
}
// MARK: - Private methods
private extension TopFiveWordsCDService {
    func mergeWordsToFive(words: [WordUIModel]) -> [WordUIModel] {
        guard !words.isEmpty else { return [] }
        var newWords = words
        let categoryId = words[0].categoryId
        var wordsFromCD = readWordsFromCoreData()
        newWords.reverse()
        wordsFromCD.reverse()
        wordsFromCD.forEach { wordFromCD in
            var flag = true
            words.forEach { word in
                if word.id == wordFromCD.id {
                    flag = false
                }
            }
            if flag && newWords.count < 5 {
                let newWord = WordUIModel(categoryId: categoryId,
                                          translations: wordFromCD.translate ?? ["Ошибка": "Ошибка"],
                                          isLearned: false,
                                          swipesCounter: 0,
                                          id: wordFromCD.id ?? "")
                newWords.append(newWord)
            }
        }
        newWords.reverse()
        return newWords
    }

    func updateWordsInCoreData(words: [WordUIModel], userId: String) {
        deleteWordsFromCoreData()
        words.forEach { word in
            guard let entity = NSEntityDescription.entity(
                forEntityName: .topFiveWordsCDModel,
                in: persistentContainer.viewContext
            ) else {
                print(#function, "ошибка получения данных из coreData")
                return
            }
            
            let wordToCoreData = TopFiveWordsCDModel(entity: entity, insertInto: persistentContainer.viewContext)
            wordToCoreData.id = word.id
            wordToCoreData.date = Date.now
            wordToCoreData.translate = word.translations
            wordToCoreData.userId = userId
            try? wordToCoreData.managedObjectContext?.save()
        }
    }

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
}
