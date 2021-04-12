//
//  AddUserViewModel.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 10/04/2021.
//

import Foundation

protocol AddUserCoordinatorDelegate: class {
    func addUserCancelButtonTapped()
    func userSuccessfullyAdded(user: User)
}

protocol AddUserViewDelegate: class {
    func errorAddingUser()
}

class AddUserViewModel {
    
    weak var viewDelegate: AddUserViewDelegate?
    weak var coordinatorDelegate: AddUserCoordinatorDelegate?
    let dataManager: AddUserDataManager
    
    init(dataManager: AddUserDataManager) {
        self.dataManager = dataManager
    }
    
    func cancelButtonTapped() {
        coordinatorDelegate?.addUserCancelButtonTapped()
    }

    func submitButtonTapped(name: String) {
                    
        dataManager.addUser(name: name, createdAt: Date()) { [weak self] (user) in
            self?.coordinatorDelegate?.userSuccessfullyAdded(user: user)
        }
        
    }
}
