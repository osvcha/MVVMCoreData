//
//  AddTaskDataManager.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 07/03/2021.
//

import Foundation

protocol AddTaskDataManager: class {
    func addTask(title: String, user: User, createdAt: Date, completion: @escaping (Task) -> ())

}
