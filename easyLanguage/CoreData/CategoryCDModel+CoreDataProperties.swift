//
//  CategoryCDModel+CoreDataProperties.swift
//  easyLanguage
//
//  Created by Grigoriy on 18.05.2024.
//
//

import Foundation
import CoreData

extension CategoryCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCDModel> {
        return NSFetchRequest<CategoryCDModel>(entityName: .categoryCDModel)
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var index: Int64
    @NSManaged public var linkedWordsId: String?
    @NSManaged public var studiedWordsCount: Int64
    @NSManaged public var title: String?
    @NSManaged public var totalWordsCount: Int64
    @NSManaged public var isDefault: Bool

}

extension CategoryCDModel : Identifiable {

}
