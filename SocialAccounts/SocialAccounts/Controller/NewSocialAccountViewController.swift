//
//  NewSocialAccountViewController.swift
//  SocialAccounts
//
//  Created by Sabir Myrzaev on 13.02.2022.
//

import UIKit

class MCTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 4
        borderStyle = UITextField.BorderStyle.roundedRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewSocialAccountViewController: UIViewController {
    
    fileprivate var titleField: UITextField = MCTextField()
    fileprivate var urlField: UITextField = MCTextField()
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New title"
        return label
    }()
    fileprivate var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New URL"
        return label
    }()
    
    var delegate: NewSocialAccountDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        self.navigationItem.title = "Add new account"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(AddNewSocial))
        
        setupUI()
        
    }
    
    fileprivate func setupUI() {
        
        let views: [UIView] = [
            titleLabel,
            titleField,
            urlLabel,
            urlField
        ]
        let stack: UIStackView = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        titleField.translatesAutoresizingMaskIntoConstraints = false
        urlField.translatesAutoresizingMaskIntoConstraints = false
        
        stack.heightAnchor.constraint(equalToConstant: 180).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    }
    
    @objc fileprivate func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func AddNewSocial() {
        let newTitle: String = titleField.text ?? ""
        let newURL: String = urlField.text ?? ""
        
        let emptyFieldColor = UIColor.red.cgColor
        
        if newTitle.isEmpty {
            titleField.layer.borderColor = emptyFieldColor
        } else {
            titleField.layer.borderColor = UIColor.gray.cgColor
        }
        if newURL.isEmpty {
            urlField.layer.borderColor = emptyFieldColor
        } else {
            urlField.layer.borderColor = UIColor.gray.cgColor
        }
        
        // if the UITextField have text in them, then dismiss the controller
        if !newTitle.isEmpty && !newURL.isEmpty {
            dismiss(animated: true) {
                guard let delegate = self.delegate else { return }
                delegate.newSocialAccount(title: newTitle, url: newURL)
            }
        }
    }
}
