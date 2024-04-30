//
//  WordCoreDataModel+CoreDataClass.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 30.04.2024.
//
//

//import Foundation
//import CoreData
//
//@objc(WordCoreDataModel)
//public class WordCoreDataModel: NSManagedObject {
//    init(ui: WordUIModel, context: NSManagedObjectContext) {
//        let entity = NSEntityDescription.entity(forEntityName: "WordCoreDataModel", in: context)
//        super.init(entity: entity!, insertInto: context)
//        
//        self.categoryId = UUID(uuidString: ui.categoryId)
//        self.id = UUID(uuidString: ui.id)
//        self.isLearned = ui.isLearned
//        self.translations = ui.translations
//        self.swipesCounter = Int64(ui.swipesCounter)
//    }
//}

import Foundation
import CoreData

@objc(WordCoreDataModel)
public class WordCoreDataModel: NSManagedObject {

}
