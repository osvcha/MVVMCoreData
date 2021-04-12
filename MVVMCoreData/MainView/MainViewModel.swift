//
//  MainViewModel.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 15/2/21.
//

import Foundation

protocol MainCoordinatorDelegate: class {
    func didSelect(user: User)
    func userPlusButtonTapped()
}

protocol MainViewDelegate: class {
    func mainDataChange(changeset: Changeset)
}

struct Changeset {
    let insertions: [IndexPath]
    let deletions: [IndexPath]
    let moves: [(IndexPath, IndexPath)]
    let updates: [IndexPath]
}

class MainViewModel {
    
    weak var coordinatorDelegate: MainCoordinatorDelegate?
    weak var viewDelegate: MainViewDelegate?
    let dataManager: MainDataManager
    var viewModels: [MainCellViewModel] = []
    
    
    init(dataManager: MainDataManager) {
        self.dataManager = dataManager
    }
    
    func viewWasLoaded() {
        
        self.viewModels = []
        
        //cargo los usuarios desde el data manager
        dataManager.fetchUsers { [weak self] (result) in
            for user in result {
                let mainCell = MainCellViewModel(user: user)
                self?.viewModels.append(mainCell)
            }
        }
        
        dataManager.startListeningChangesOnUsers() { [weak self] (changes) in
            // Create a mutable list of viewmodels
            guard var mutableViewModels = self?.viewModels else { return }
            // Collect the indexpath of changing operations: Insert, delete, move and update
            // Then, we pass the changes to the views and perform a batch updates over the table for animated updating
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
                case let .update(userAny, indexPath):
                    updatesIndexPaths.append(indexPath)
                    guard let user = userAny as? User else {return}
                    mutableViewModels[indexPath.row] = MainCellViewModel(user: user)
                }
            }
            
            
            //ordeno insertions
            insertions.sort { (first, second) -> Bool in
                guard case let .insert(_, firstIndexPath) = first else { return false }
                guard case let .insert(_, secondIndexPath) = second else { return false }
                return firstIndexPath < secondIndexPath
            }
            
            for insertion in insertions {
                guard case let .insert(userAny, indexPath) = insertion else { continue }
                insertionIndexPaths.append(indexPath)
                guard let user = userAny as? User else {return}
                mutableViewModels.insert(MainCellViewModel(user: user), at: 0)
            }
            
            //ordeno deletions
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
            
            
            // Preparamos los cambios de indexpaths para la vista
            let changeset = Changeset(insertions: insertionIndexPaths,
                                      deletions: deletionIndexPaths,
                                      moves: moveIndexPaths,
                                      updates: updatesIndexPaths)
            
            // Primero actualizamos nuestro listado
            self?.viewModels = mutableViewModels

            // Y finalmente avisamos a la vista
            self?.viewDelegate?.mainDataChange(changeset: changeset)
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
        coordinatorDelegate?.didSelect(user: viewModels[indexPath.row].user)
    }
    
    
    
    func getObject(at indexPath: IndexPath) -> MainCellViewModel? {
        guard indexPath.row < viewModels.count else { return nil }
        
        return viewModels[indexPath.row]
    }
    
    func deleteAllButtonTapped() {
        dataManager.deleteAllObjects()
    }
    
    func deleteUserButtonTapped(at indexPath: IndexPath) {
        dataManager.deleteUser(at: indexPath)
    }
    
    
    func addDummyButtonTapped() {
        dataManager.createDummyContent()
    }
    
    func plusButtonTapped() {
        coordinatorDelegate?.userPlusButtonTapped()
    }
}
