//
//  WordCDModel+CoreDataProperties.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 13.05.2024.
//
//

import Foundation
import CoreData

extension WordCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordCDModel> {
        return NSFetchRequest<WordCDModel>(entityName: .wordCDModel)
    }

    @NSManaged public var categoryId: String?
    @NSManaged public var translations: [String: String]?
    @NSManaged public var isLearned: Bool
    @NSManaged public var swipesCounter: Int64
    @NSManaged public var id: String?

}

extension WordCDModel: Identifiable {

}
