//
//  LocalDataManager.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 15/2/21.
//

import Foundation

protocol LocalDataManager {
    func startListeningChangesOnUsers(objectChanged: @escaping ChangeClosure)
    func startListeningChangesOnTasks(user: User, objectChanged: @escaping ChangeClosure)
    func fetchUsers(completion: @escaping ([User]) -> Void)
    func fetchTasks(user: User, completion: @escaping ([Task]) -> Void)
    func deleteAllObjects()
    func deleteUser(at: IndexPath)
    func deleteTask(at: IndexPath)
    func addTask(title: String, user: User, createdAt: Date, completion: @escaping (Task) -> Void)
    func addUser(name: String, createdAt: Date, completion: @escaping (User) -> Void)
    func createDummyContent()
    func saveContext()
}
