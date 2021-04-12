//
//  DataManager.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 15/2/21.
//

import Foundation

class DataManager {
    let localDataManager: LocalDataManager
    
    init(localDataManager: LocalDataManager) {
        self.localDataManager = localDataManager
    }
}


extension DataManager: MainDataManager {
    func startListeningChangesOnUsers(objectChanged: @escaping ChangeClosure) {
        localDataManager.startListeningChangesOnUsers(objectChanged: objectChanged)
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        localDataManager.fetchUsers(completion: completion)
    }
    
    func deleteAllObjects() {
        localDataManager.deleteAllObjects()
    }
    
    func deleteUser(at indexPath: IndexPath) {
        localDataManager.deleteUser(at: indexPath)
    }
    
    func createDummyContent() {
        localDataManager.createDummyContent()
    }
    
    func saveContext() {
        localDataManager.saveContext()
    }
    
}

extension DataManager: AddUserDataManager {
    func addUser(name: String, createdAt: Date, completion: @escaping (User) -> ()) {
        localDataManager.addUser(name: name, createdAt: createdAt, completion: completion)
    }
    
    
}

extension DataManager: TasksDataManager {
    
    func startListeningChangesOnTasks(user: User, objectChanged: @escaping ChangeClosure) {
        localDataManager.startListeningChangesOnTasks(user: user, objectChanged: objectChanged)
    }
    
    func fetchTasks(user: User, completion: @escaping ([Task]) -> Void) {
        localDataManager.fetchTasks(user: user, completion: completion)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        localDataManager.deleteTask(at: indexPath)
    }
    
}

extension DataManager: AddTaskDataManager {
    func addTask(title: String, user: User, createdAt: Date, completion: @escaping (Task) -> ()) {
        localDataManager.addTask(title: title, user: user, createdAt: createdAt, completion: completion)
    }
    
    
}
