//
//  CategoryCDModel+CoreDataProperties.swift
//  easyLanguage
//
//  Created by Grigoriy on 17.05.2024.
//
//

import Foundation
import CoreData

extension CategoryCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCDModel> {
        return NSFetchRequest<CategoryCDModel>(entityName: .categoryCDModel)
    }

    @NSManaged public var title: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var studiedWordsCount: Int64
    @NSManaged public var totalWordsCount: Int64
    @NSManaged public var createdDate: Date?
    @NSManaged public var linkedWordsId: String?
    @NSManaged public var index: Int64

}

extension CategoryCDModel: Identifiable {

}
