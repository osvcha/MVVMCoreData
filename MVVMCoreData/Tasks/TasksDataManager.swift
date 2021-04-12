//
//  TasksDataManager.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 02/03/2021.
//

import Foundation

protocol TasksDataManager: class {
    func startListeningChangesOnTasks(user: User, objectChanged: @escaping ChangeClosure)
    func fetchTasks(user: User, completion: @escaping ([Task]) -> Void)
    func deleteTask(at: IndexPath)

}
