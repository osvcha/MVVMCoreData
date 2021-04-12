//
//  TasksViewModel.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 02/03/2021.
//

import Foundation

protocol TasksCoordinatorDelegate: class {
    func didSelect(task: Task)
    func tasksPlusButtonTapped(user: User)
}

protocol TasksViewDelegate: class {
    func tasksDataChange(changeset: Changeset)
}

class TasksViewModel {
    
    weak var coordinatorDelegate: TasksCoordinatorDelegate?
    weak var viewDelegate: TasksViewDelegate?
    let dataManager: TasksDataManager
    var viewModels: [TaskCellViewModel] = []
    var user: User?
    
    init(user: User, dataManager: TasksDataManager) {
        self.user = user
        self.dataManager = dataManager
    }
    
    func viewWasLoaded() {
        guard let user = user else {return}
        
        dataManager.fetchTasks(user: user) { [weak self] (result) in
            for task in result {
                let taskCell = TaskCellViewModel(task: task)
                self?.viewModels.append(taskCell)
            }
        }
        
        dataManager.startListeningChangesOnTasks(user: user) { [weak self] (changes) in
            
            guard var mutableViewModels = self?.viewModels else { return }
            
            var insertions: [Change] = []
            var insertionIndexPaths: [IndexPath] = []
            var deletions: [Change] = []
            var deletionIndexPaths: [IndexPath] = []
            var moveIndexPaths: [(IndexPath, IndexPath)] = []
            var updatesIndexPaths: [IndexPath] = []
            
            for change in changes {
                switch change {
                case .delete:
                    deletions.append(change)
                case .insert:
                    insertions.append(change)
                case let .move(fromIndexPath, toIndexPath):
                    moveIndexPaths.append((fromIndexPath, toIndexPath))
                    mutableViewModels.swapAt(fromIndexPath.row, toIndexPath.row)
                case let .update(taskAny, indexPath):
                    updatesIndexPaths.append(indexPath)
                    guard let task = taskAny as? Task else {return}
                    mutableViewModels[indexPath.row] = TaskCellViewModel(task: task)
                }
            }
            
            for insertion in insertions {
                guard case let .insert(taskAny, indexPath) = insertion else { continue }
                insertionIndexPaths.append(indexPath)
                guard let task = taskAny as? Task else {return}
                mutableViewModels.insert(TaskCellViewModel(task: task), at: 0)
            }
            
            //Order deletions
            deletions.sort { (first, second) -> Bool in
                guard case let .delete(firstIndexPath) = first else {return false}
                guard case let .delete(secondIndexPath) = second else {return false}
                return firstIndexPath > secondIndexPath
            }
            
            for deletion in deletions {
                guard case let .delete(indexPath) = deletion else { continue }
                
                deletionIndexPaths.append(indexPath)
                mutableViewModels.remove(at: indexPath.row)
            }
            
            
            // Prepare the indexpaths of changes for the view
            let changeset = Changeset(insertions: insertionIndexPaths,
                                      deletions: deletionIndexPaths,
                                      moves: moveIndexPaths,
                                      updates: updatesIndexPaths)
            
            // Updating our list of viewmodels
            self?.viewModels = mutableViewModels
            
            // Tell to the view
            self?.viewDelegate?.tasksDataChange(changeset: changeset)
            
            
        }
        
        
        
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return viewModels.count
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.row < viewModels.count else { return }
        coordinatorDelegate?.didSelect(task: viewModels[indexPath.row].task)
    }
    
    
    
    func getObject(at indexPath: IndexPath) -> TaskCellViewModel? {
        guard indexPath.row < viewModels.count else { return nil }
        
        return viewModels[indexPath.row]
    }
    
    
    
    func deleteTaskButtonTapped(at indexPath: IndexPath) {
        dataManager.deleteTask(at: indexPath)
    }
    
    func plusButtonTapped() {
        guard let user = user else {return}
        coordinatorDelegate?.tasksPlusButtonTapped(user: user)
    }
    

    
}
