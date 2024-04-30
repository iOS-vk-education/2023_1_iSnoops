//
//  WordCoreDataModel+CoreDataProperties.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 30.04.2024.
//
//

import Foundation
import CoreData


extension WordCoreDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordCoreDataModel> {
        return NSFetchRequest<WordCoreDataModel>(entityName: "WordCoreDataModel")
    }

    @NSManaged public var categoryId: UUID?
    @NSManaged public var translations: NSObject?
    @NSManaged public var isLearned: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var swipesCounter: Int64

}

extension WordCoreDataModel : Identifiable {

}
