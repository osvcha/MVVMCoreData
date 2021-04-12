//
//  AppCoordinator.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 07/02/2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private lazy var localDataManager: LocalDataManager = {
        let localDataManager = LocalDataManagerCoreData()
        return localDataManager
    }()
    
    private lazy var dataManager: DataManager = {
        let dataManager = DataManager(localDataManager: localDataManager)
        return dataManager
    }()
    
    
    private var window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    override func start() {

        let mainNavigationController = UINavigationController()
        let mainCoordinator = MainCoordinator(presenter: mainNavigationController,
                                                        mainDataManager: dataManager,
                                                        tasksDataManager: dataManager,
                                                        addTaskDataManager: dataManager,
                                                        addUserDataManager: dataManager)

        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()

        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
    }

    override func finish() {}
    
    func saveContext() {
        dataManager.saveContext()
    }
    
}
