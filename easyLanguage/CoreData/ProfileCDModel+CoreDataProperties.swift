//
//  ProfileCDModel+CoreDataProperties.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.05.2024.
//
//

import Foundation
import CoreData


extension ProfileCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileCDModel> {
        return NSFetchRequest<ProfileCDModel>(entityName: "ProfileCDModel")
    }

    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var time: Date?
    @NSManaged public var userId: String?

}

extension ProfileCDModel : Identifiable {

}
