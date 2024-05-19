////
////  CoreDataSyncService.swift
////  easyLanguage
////
////  Created by Grigoriy on 19.05.2024.
////
//
//import Foundation
//import CoreData
//import FirebaseFirestore
//import FirebaseStorage
//import FirebaseAuth
//
//
//protocol ICoreDataSyncService {
//    func syncAllDataToFirebase()
//}
///// из coreData данные в бек
//class CoreDataSyncService {
//    static let shared: ICoreDataSyncService = CoreDataSyncService()
//    
//    private let coreDataService = CoreDataService()
//    private let dataBase = Firestore.firestore()
//
//    private init() {}
//
//    private enum Constants {
//        static let imageLink = "imageLink"
//    }
//
//    // swiftlint:disable:next line_length
//    private let defaultImageLink = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2F1E1922CE-61D4-46BE-B2C7-4E12B316CCFA?alt=media&token=80174f66-ee40-4f34-9a35-8d7ed4fbd571"
//}
//
//extension CoreDataSyncService: ICoreDataSyncService {
//    func syncAllDataToFirebase() {
//        guard let userId = getCurrentUserId() else {
//            return
//        }
//
//        let context = coreDataService.persistentContainer.viewContext
//
//        // Fetch all categories
//        let categoryFetchRequest: NSFetchRequest<CategoryCDModel> = CategoryCDModel.fetchRequest()
//        do {
//            let categories = try context.fetch(categoryFetchRequest)
//            for category in categories {
//                uploadCategory(category)
//            }
//        } catch {
//            print("Failed to fetch categories: \(error)")
//        }
//
//        // Fetch all words
//        let wordFetchRequest: NSFetchRequest<WordCDModel> = WordCDModel.fetchRequest()
//        do {
//            let words = try context.fetch(wordFetchRequest)
//            for word in words {
//                uploadWord(word, userId: userId)
//            }
//        } catch {
//            print("Failed to fetch words: \(error)")
//        }
//
//        // Fetch profile
//        if let profile = fetchProfile() {
//            uploadProfile(profile, userId: userId)
//        }
//    }
//
//    private func getCurrentUserId() -> String? {
//        return Auth.auth().currentUser?.uid
//    }
//
//    // с бека
//    private func uploadCategory(category) {
//        
//    }
//}
