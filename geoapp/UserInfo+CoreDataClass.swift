//
//  UserInfo+CoreDataClass.swift
//  geoapp
//
//  Created by Quan Dao on 24.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//
//

import Foundation
import CoreData

public class UserInfo: NSManagedObject {
    class func getOrCreateUserInfoWith(token: String) throws -> UserInfo? {
        let request:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        request.predicate = NSPredicate(format: "token = %@", token)
        
        do {
            let matchingNews = try AppDelegate.viewContext.fetch(request)
            if matchingNews.count == 1 {
                return matchingNews[0]
            }
            else if matchingNews.count == 0 {
                let newNews = UserInfo(context: AppDelegate.viewContext)
                return newNews
            }
            else {
                print("Database inconsistent found equal news")
                return matchingNews[0]
            }
        } catch {
            throw error
        }
    }
}
