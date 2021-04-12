//
//  AddTaskCoordinator.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 07/03/2021.
//

import UIKit

class AddTaskCoordinator: Coordinator {
    let presenter: UINavigationController
    let addTaskDataManager: AddTaskDataManager
    var addTaskNavigationController: UINavigationController?
    var user: User?
    var onCancelTapped: (() -> Void)?
    var onTaskCreated: ((Task) -> Void)?
    
    init(presenter: UINavigationController, user: User, addTaskDataManager: AddTaskDataManager) {
        self.presenter = presenter
        self.user = user
        self.addTaskDataManager = addTaskDataManager
    }
    
    override func start() {
        guard let user = user else {return}
        let addTaskViewModel = AddTaskViewModel(user: user, dataManager: addTaskDataManager)
        addTaskViewModel.coordinatorDelegate = self
        
        let addTaskViewController = AddTaskViewController(viewModel: addTaskViewModel)
        addTaskViewModel.viewDelegate = addTaskViewController
        addTaskViewController.isModalInPresentation = true
        addTaskViewController.title = "Add task"
        
        let navigationController = UINavigationController(rootViewController: addTaskViewController)
        self.addTaskNavigationController = navigationController
        presenter.present(navigationController, animated: true, completion: nil)
        
    }
    
    override func finish() {
        addTaskNavigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AddTaskCoordinator: AddTaskCoordinatorDelegate {

    
    func addTaskCancelButtonTapped() {
        onCancelTapped?()
    }

    func taskSuccessfullyAdded(task: Task) {
        onTaskCreated?(task)
    }
}
