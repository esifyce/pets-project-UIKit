//
//  EnterDataViewController.swift
//  CoreDataExamole
//
//  Created by Krasivo on 25.11.2023.
//

import UIKit

class EnterDataViewController: UIViewController {
    
    // MARK: - Property
    
    var person: Person?
    
    // MARK: - Views
    
    private let lastNameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Фамилия"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        tf.textColor = .black
        tf.textAlignment = .left
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 0.5
        return tf
    }()

    private let ageTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Возраст"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        tf.textColor = .black
        tf.textAlignment = .left
        tf.keyboardType = .numberPad
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 0.5
        return tf
    }()
    
    // MARK: - Lifecycle VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

private extension EnterDataViewController {
    func configureUI() {
        view.backgroundColor = .white

        configureNavigation()
        addViews()
        addConstraints()
        
        if let person {
            lastNameTextField.text = "\(person.name ?? "")"
            ageTextField.text = "\(person.age)"
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "Ввод данных"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    func addViews() {
        view.addSubview(lastNameTextField)
        view.addSubview(ageTextField)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            lastNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            ageTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ageTextField.heightAnchor.constraint(equalToConstant: 50),
        
        ])
    }
    
    func savePerson() -> Bool {
        if let lastNameText = lastNameTextField.text, lastNameText.isEmpty {
            let alert = UIAlertController(title: "Ошибка ввода", message: "Вы не заполнили поле - Фамилия", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
            return false
        }
        
        if person == nil {
            person = Person()
        }
        
        if let person {
            person.name = lastNameTextField.text
            person.age = Int16(ageTextField.text ?? "0") ?? .zero
            CoreDataManager.instance.saveContext()
        }
        return true
    }
}

@objc private extension EnterDataViewController {
    func save() {
        guard savePerson() else { return }
        navigationController?.popViewController(animated: true)
    }
    
    func cancel() {
        navigationController?.popViewController(animated: true)
    }
}
