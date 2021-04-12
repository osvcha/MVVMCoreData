//
//  AddTaskViewController.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 07/03/2021.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    let borderColor: UIColor = .mainColor
    
    lazy var titleField: TextFieldWithPadding = {
        let titleField = TextFieldWithPadding()
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.borderStyle = .none
        titleField.font = UIFont.systemFont(ofSize: 16)
        titleField.placeholder = NSLocalizedString("Insert task title", comment: "")
        titleField.layer.borderWidth = 0.5
        titleField.layer.borderColor = borderColor.cgColor
        titleField.layer.cornerRadius = CGFloat(10)
        return titleField
    }()
    
    let viewModel: AddTaskViewModel
    
    init(viewModel: AddTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(titleField)
        
        NSLayoutConstraint.activate([
            titleField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle(NSLocalizedString("Submit", comment: ""), for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        submitButton.backgroundColor = .mainColor
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)

        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            submitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            submitButton.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16)
        ])
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"), style: .plain, target: self, action: #selector(cancelButtonTapped))
        rightBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc fileprivate func cancelButtonTapped() {
        viewModel.cancelButtonTapped()
    }

    @objc fileprivate func submitButtonTapped() {
        guard let title = titleField.text, !title.isEmpty else { return }
        viewModel.submitButtonTapped(title: title)
    }

    fileprivate func showErrorAddingTaskAlert() {
        let message = NSLocalizedString("Error adding task", comment: "")
        showAlert(message)
    }
    
}

extension AddTaskViewController: AddTaskViewDelegate {
    func errorAddingTask() {
        showErrorAddingTaskAlert()
    }
}

