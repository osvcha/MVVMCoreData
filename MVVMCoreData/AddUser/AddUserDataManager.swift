//
//  AddTaskDataManager.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 10/04/2021.
//

import Foundation

protocol AddUserDataManager: class {
    func addUser(name: String, createdAt: Date, completion: @escaping (User) -> ())

}
