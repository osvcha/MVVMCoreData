//
//  AddUserCoordinator.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 10/04/2021.
//

import UIKit

class AddUserCoordinator: Coordinator {
    let presenter: UINavigationController
    let addUserDataManager: AddUserDataManager
    var addUserNavigationController: UINavigationController?
    var onCancelTapped: (() -> Void)?
    var onUserCreated: ((User) -> Void)?
    
    init(presenter: UINavigationController, addUserDataManager: AddUserDataManager) {
        self.presenter = presenter
        self.addUserDataManager = addUserDataManager
    }
    
    override func start() {
        let addUserViewModel = AddUserViewModel(dataManager: addUserDataManager)
        addUserViewModel.coordinatorDelegate = self
        
        let addUserViewController = AddUserViewController(viewModel: addUserViewModel)
        addUserViewModel.viewDelegate = addUserViewController
        addUserViewController.isModalInPresentation = true
        addUserViewController.title = "Add user"
        
        let navigationController = UINavigationController(rootViewController: addUserViewController)
        self.addUserNavigationController = navigationController
        presenter.present(navigationController, animated: true, completion: nil)
        
    }
    
    override func finish() {
        addUserNavigationController?.dismiss(animated: true, completion: nil)
    }
}

extension AddUserCoordinator: AddUserCoordinatorDelegate {

    
    func addUserCancelButtonTapped() {
        onCancelTapped?()
    }

    func userSuccessfullyAdded(user: User) {
        onUserCreated?(user)
    }
}
