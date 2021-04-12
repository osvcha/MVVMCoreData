//
//  AddTaskViewModel.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 07/03/2021.
//

import Foundation

protocol AddTaskCoordinatorDelegate: class {
    func addTaskCancelButtonTapped()
    func taskSuccessfullyAdded(task: Task)
}

protocol AddTaskViewDelegate: class {
    func errorAddingTask()
}

class AddTaskViewModel {
    
    weak var viewDelegate: AddTaskViewDelegate?
    weak var coordinatorDelegate: AddTaskCoordinatorDelegate?
    let dataManager: AddTaskDataManager
    var user: User?
    
    init(user: User, dataManager: AddTaskDataManager) {
        self.dataManager = dataManager
        self.user = user
    }
    
    func cancelButtonTapped() {
        coordinatorDelegate?.addTaskCancelButtonTapped()
    }

    func submitButtonTapped(title: String) {
                        
        guard let user = user else { return }
        dataManager.addTask(title: title, user: user, createdAt: Date()) { [weak self] (task) in
            self?.coordinatorDelegate?.taskSuccessfullyAdded(task: task)
        }
        
        
    }
    
    
}
