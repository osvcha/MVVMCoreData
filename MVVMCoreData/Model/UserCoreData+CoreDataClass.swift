//
//  UserCoreData+CoreDataClass.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 18/02/2021.
//
//

import Foundation
import CoreData

@objc(UserCoreData)
public class UserCoreData: NSManagedObject {
    
    @discardableResult
    static func createUser(createdAt: Date,
                           name: String,
                           order: Int16,
                           in managedObjectContext: NSManagedObjectContext) -> UserCoreData? {
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserCoreData",
                                                           into: managedObjectContext) as? UserCoreData
        user?.createdAt = createdAt
        user?.name = name
        user?.order = order
        return user
    }
    
}
