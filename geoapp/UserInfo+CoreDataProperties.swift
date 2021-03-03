//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by Quan Dao on 24.4.2020.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var token: String?

}
