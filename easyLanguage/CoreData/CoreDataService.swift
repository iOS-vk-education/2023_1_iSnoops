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

// MARK: - Words Methods

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
        updateProfileTime()
    }

    // загрузка количества слов, связанных с этой категорией (для главного экрана)
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
            updateProfileTime()
        } catch {
            print("deleteWords error \(error)")
        }
    }

    func reloadIsLearned(with id: String, isLearned: Bool, swipesCounter: Int) {
        let fetchRequest: NSFetchRequest<WordCDModel> = WordCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let words = try persistentContainer.viewContext.fetch(fetchRequest)
            if let word = words.first {
                word.isLearned = isLearned
                word.swipesCounter = Int64(swipesCounter)
                try persistentContainer.viewContext.save()
            }
        } catch {
            print(#function, "не получилось обновить IsLearned \(error.localizedDescription)")
        }
    }

    func deleteWord(with id: String) throws -> Error? {
        let fetchRequest: NSFetchRequest<WordCDModel> = WordCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let words = try persistentContainer.viewContext.fetch(fetchRequest)
            if let word = words.first {
                persistentContainer.viewContext.delete(word)
                try persistentContainer.viewContext.save()
                updateProfileTime()
            }
        } catch {
            return error
        }
        return nil
    }

    /// для изучения конкретной категории, подгружаем неизученные слова
    func loadWordsInCategory(with categoryId: String) async throws -> [WordUIModel] {
        return try await withCheckedThrowingContinuation { continuation in
            let fetchRequest: NSFetchRequest<WordCDModel> = WordCDModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "categoryId == %@ AND isLearned == %@",
                categoryId, NSNumber(value: false)
            )

            do {
                let words = try persistentContainer.viewContext.fetch(fetchRequest)
                let wordUIModels = words.map { word in
                    WordUIModel(
                        categoryId: word.categoryId ?? "",
                        translations: word.translations ?? [:],
                        isLearned: word.isLearned,
                        swipesCounter: Int(word.swipesCounter),
                        id: word.id ?? ""
                    )
                }
                continuation.resume(returning: wordUIModels)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

// MARK: - Categories Methods

extension CoreDataService {
    func saveCategory(with category: CategoryModel, imageData: Data? = nil) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: .categoryCDModel,
            in: persistentContainer.viewContext
        ) else {
            print(#function, "ошибка получения данных из coreData")
            return
        }

        let categoryToCoreData = CategoryCDModel(entity: entity, insertInto: persistentContainer.viewContext)

        categoryToCoreData.createdDate = category.createdDate
        categoryToCoreData.index = Int64(category.index ?? 0)
        categoryToCoreData.linkedWordsId = category.linkedWordsId
        categoryToCoreData.studiedWordsCount = Int64(category.studiedWordsCount)
        categoryToCoreData.totalWordsCount = Int64(category.totalWordsCount)
        categoryToCoreData.title = category.title
        categoryToCoreData.imageData = imageData
        categoryToCoreData.isDefault = category.isDefault

        try? categoryToCoreData.managedObjectContext?.save()
        updateProfileTime()
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
            updateProfileTime()
            return nil
        } catch {
            return error
        }
    }
}

// MARK: - Profile Methods
extension CoreDataService {
    func saveProfile(username: String, email: String, userId: String, time: Date) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: .profileCDModel,
            in: persistentContainer.viewContext
        ) else {
            print(#function, "ошибка получения данных из coreData")
            return
        }

        let profile = ProfileCDModel(entity: entity, insertInto: persistentContainer.viewContext)
        profile.username = username
        profile.email = email
        profile.userId = userId
        profile.time = time

        try? persistentContainer.viewContext.save()
    }

    // обновляем каждый раз time, чтобы потом синхронизировать с беком
    func updateProfileTime() {
        let fetchRequest: NSFetchRequest<ProfileCDModel> = ProfileCDModel.fetchRequest()

        do {
            let profiles = try persistentContainer.viewContext.fetch(fetchRequest)
            if let profile = profiles.first {
                profile.time = Date()
                try persistentContainer.viewContext.save()
            }
        } catch {
            print("Failed to update profile time: \(error.localizedDescription)")
        }
    }
}

// MARK: - удаление данных для синхронизации с беком

extension CoreDataService {
    func deleteAllData() {
        deleteAllEntities(entity: WordCDModel.self, errorMessage: "слова")
        deleteAllEntities(entity: CategoryCDModel.self, errorMessage: "категории")
        deleteAllEntities(entity: TopFiveWordsCDModel.self, errorMessage: "топ5 слов")
        deleteAllEntities(entity: ProfileCDModel.self, errorMessage: "профиль")
    }

    private func deleteAllEntities<T: NSManagedObject>(entity: T.Type, errorMessage: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            try persistentContainer.viewContext.save()
        } catch {
            print("не удалось удалить \(errorMessage): \(error.localizedDescription)")
        }
    }
}

// MARK: - извлечение времени у пользователя

extension CoreDataService {
    func fetchProfileTime() -> Date? {
        let fetchRequest: NSFetchRequest<ProfileCDModel> = ProfileCDModel.fetchRequest()

        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            return results.first?.time
        } catch {
            print("не удалось извлечь время", error)
            return nil
        }
    }
}
