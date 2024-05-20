//
//  TopFiveWordsCDModel+CoreDataProperties.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 15.05.2024.
//
//

import Foundation
import CoreData

@objc(TopFiveWordsCDModel)
public class TopFiveWordsCDModel: NSManagedObject {

}

extension TopFiveWordsCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopFiveWordsCDModel> {
        return NSFetchRequest<TopFiveWordsCDModel>(entityName: .topFiveWordsCDModel)
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var translate: [String: String]?
    @NSManaged public var userId: String?

}

extension TopFiveWordsCDModel : Identifiable {

}
