//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by nguyen thanh vy on 26.4.2020.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var token: String?
    @NSManaged public var username: String?
    @NSManaged public var score: Double

}
