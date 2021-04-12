//
//  TasksViewController.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 02/03/2021.
//

import UIKit

class TasksViewController: UIViewController {
    
    //TableView
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = .white
        return table
    }()
    
    let viewModel: TasksViewModel
    
    init(viewModel: TasksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewWasLoaded()
    }
    
    override func loadView() {
        view = UIView()
        view.addSubview(tableView)
        
        configureTheView()
        
    }
    
    func configureTheView() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let plusImage = UIImage(systemName: "plus.circle.fill")
        let rightBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(plusButtonTapped))
        rightBarButtonItem.tintColor = .mainColor
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.backgroundColor = .white
        
        
        self.navigationController?.navigationBar.tintColor = .mainColor
        
        let systemFont = UIFont.systemFont(ofSize: 18)
        let font = UIFont(name: "Noteworthy-Bold", size: 20.0)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? systemFont,
            .foregroundColor: UIColor.mainColor,
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
    }
    
    @objc func plusButtonTapped() {
        viewModel.plusButtonTapped()
    }
    
    fileprivate func showErrorFetchingTasksAlert() {
        let alertMessage: String = NSLocalizedString("Error fetching tasks try again later", comment: "")
        showAlert(alertMessage)
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell,
            let cellViewModel = viewModel.getObject(at: indexPath) {
            cell.viewModel = cellViewModel
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, complete) in
            self?.viewModel.deleteTaskButtonTapped(at: indexPath)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeAction
       
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

//MARK:- Table Delegate
extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath)
    }
    
}

extension TasksViewController: TasksViewDelegate {
    func tasksDataChange(changeset: Changeset) {
        tableView.performBatchUpdates { [weak self] in
            self?.tableView.insertRows(at: changeset.insertions, with: .automatic)
            self?.tableView.deleteRows(at: changeset.deletions, with: .automatic)
            
            for move in changeset.moves {
                self?.tableView.moveRow(at: move.0, to: move.1)
            }
            
            self?.tableView.reloadRows(at: changeset.updates, with: .automatic)
        } completion: { (success) in
            print(success)
        }
    }

    
}
