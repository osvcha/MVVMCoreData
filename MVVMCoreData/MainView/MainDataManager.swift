//
//  MainDataManager.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 15/2/21.
//

import Foundation



protocol MainDataManager: class {
    func startListeningChangesOnUsers(objectChanged: @escaping ChangeClosure)
    func fetchUsers(completion: @escaping ([User]) -> Void)
    func deleteAllObjects()
    func deleteUser(at: IndexPath)
    func createDummyContent()
}
