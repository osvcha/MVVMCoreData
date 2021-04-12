//
//  MainCoordinator.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 19/02/2021.
//

import UIKit

class MainCoordinator: Coordinator {
    
    let presenter: UINavigationController
    let mainDataManager: MainDataManager
    let tasksDataManager: TasksDataManager
    let addTaskDataManager: AddTaskDataManager
    let addUserDataManager: AddUserDataManager
    var mainViewModel: MainViewModel?
    var tasksViewModel: TasksViewModel?
    
    init(presenter: UINavigationController,
         mainDataManager: MainDataManager,
         tasksDataManager: TasksDataManager,
         addTaskDataManager: AddTaskDataManager,
         addUserDataManager: AddUserDataManager) {
        self.presenter = presenter
        self.mainDataManager = mainDataManager
        self.tasksDataManager = tasksDataManager
        self.addTaskDataManager = addTaskDataManager
        self.addUserDataManager = addUserDataManager
    }
    
    override func start() {
        let mainViewModel = MainViewModel(dataManager: mainDataManager)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.title = NSLocalizedString("Users", comment: "")
        mainViewModel.viewDelegate = mainViewController
        mainViewModel.coordinatorDelegate = self
        self.mainViewModel = mainViewModel
        presenter.pushViewController(mainViewController, animated: false)
        
        
    }
    
    override func finish() {}
    
}

extension MainCoordinator: MainCoordinatorDelegate {
    func didSelect(user: User) {
        
        let tasksViewModel = TasksViewModel(user: user, dataManager: tasksDataManager)
        tasksViewModel.coordinatorDelegate = self
        let tasksViewController = TasksViewController(viewModel: tasksViewModel)
        tasksViewController.title = NSLocalizedString(user.name, comment: "")
        tasksViewModel.viewDelegate = tasksViewController
        self.tasksViewModel = tasksViewModel
        presenter.pushViewController(tasksViewController, animated: true)

    }
    
    func userPlusButtonTapped() {
        let addUserCoordinator = AddUserCoordinator(presenter: presenter, addUserDataManager: addUserDataManager)
        addChildCoordinator(addUserCoordinator)
        addUserCoordinator.start()

        addUserCoordinator.onCancelTapped = { [weak self] in
            guard let self = self else { return }

            addUserCoordinator.finish()
            self.removeChildCoordinator(addUserCoordinator)
        }

        addUserCoordinator.onUserCreated = { [weak self] (user) in
            guard let self = self else { return }
            addUserCoordinator.finish()
            self.removeChildCoordinator(addUserCoordinator)
        }
    }
    
}

extension MainCoordinator: TasksCoordinatorDelegate {
    func tasksPlusButtonTapped(user: User) {
        let addTaskCoordinator = AddTaskCoordinator(presenter: presenter, user: user, addTaskDataManager: addTaskDataManager)
        addChildCoordinator(addTaskCoordinator)
        addTaskCoordinator.start()

        addTaskCoordinator.onCancelTapped = { [weak self] in
            guard let self = self else { return }

            addTaskCoordinator.finish()
            self.removeChildCoordinator(addTaskCoordinator)
        }

        addTaskCoordinator.onTaskCreated = { [weak self] (task) in
            guard let self = self else { return }
            addTaskCoordinator.finish()
            self.removeChildCoordinator(addTaskCoordinator)
        }
    }
    
    func didSelect(task: Task) {
        print(task.title)
    }
    
    
}
