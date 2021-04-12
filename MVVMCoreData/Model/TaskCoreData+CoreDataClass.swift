//
//  TaskCoreData+CoreDataClass.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 07/03/2021.
//
//

import Foundation
import CoreData

@objc(TaskCoreData)
public class TaskCoreData: NSManagedObject {
    
    @discardableResult
    static func createTask(createdAt: Date,
                           user: UserCoreData,
                           title: String,
                           in managedObjectContext: NSManagedObjectContext) -> TaskCoreData? {
        let task = NSEntityDescription.insertNewObject(forEntityName: "TaskCoreData",
                                                           into: managedObjectContext) as? TaskCoreData
        task?.createdAt = createdAt
        task?.title = title
        task?.user = user
        return task
    }
    
}
