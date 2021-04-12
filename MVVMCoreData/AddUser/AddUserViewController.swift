//
//  AddUserViewController.swift
//  MVVMCoreData
//
//  Created by Osvaldo Chaparro on 10/04/2021.
//

import UIKit

class AddUserViewController: UIViewController {
    
    let borderColor: UIColor = .mainColor
    
    lazy var nameField: TextFieldWithPadding = {
        let field = TextFieldWithPadding()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .none
        field.font = UIFont.systemFont(ofSize: 16)
        field.placeholder = NSLocalizedString("Insert user name", comment: "")
        field.layer.borderWidth = 0.5
        field.layer.borderColor = borderColor.cgColor
        field.layer.cornerRadius = CGFloat(10)
        return field
    }()
    
    let viewModel: AddUserViewModel
    
    init(viewModel: AddUserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(nameField)
        
        NSLayoutConstraint.activate([
            nameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
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
            submitButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16)
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
        guard let name = nameField.text, !name.isEmpty else { return }
        viewModel.submitButtonTapped(name: name)
    }
    
    fileprivate func showErrorAddingUserAlert() {
        let message = NSLocalizedString("Error adding user", comment: "")
        showAlert(message)
    }
}

extension AddUserViewController: AddUserViewDelegate {
    func errorAddingUser() {
        showErrorAddingUserAlert()
    }
}
