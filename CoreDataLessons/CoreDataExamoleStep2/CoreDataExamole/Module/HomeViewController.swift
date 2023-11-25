//
//  HomeViewController.swift
//  CoreDataExamole
//
//  Created by Krasivo on 25.11.2023.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    // MARK: - Property
    
    private let appearance = Appearance()
    
    private lazy var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: appearance.entity)
        let sortDescriptor = NSSortDescriptor(key: appearance.sortName, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }()
    
    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: appearance.cellName)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Lifecycle VC

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchResult()
        
        fetchResultController.delegate = self
    }
}

// MARK: - Appearance

extension HomeViewController {
    struct Appearance {
        let entity = "Person"
        let sortName = "name"
        let cellName = "Cell"
    }
}

// MARK: - private methods

private extension HomeViewController {
    func configureUI() {
        view.backgroundColor = .systemMint

        addViews()
        addConstraints()
        configureNav()
    }
    
    func configureNav() {
        navigationItem.title = "Список персонала"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson))
    }
    
    func addViews() {
        view.addSubview(tableView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchResult() {
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return .zero
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: appearance.cellName, for: indexPath)
        if let person = fetchResultController.object(at: indexPath) as? Person {
            cell.textLabel?.text = "\(person.name ?? "") - \(person.age)"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = fetchResultController.object(at: indexPath)
        
        if let person = person as? Person {
            let viewController = EnterDataViewController()
            viewController.person = person
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = fetchResultController.object(at: indexPath)
            if let person = person as? Person {
                CoreDataManager.instance.context.delete(person)
                CoreDataManager.instance.saveContext()
            }
        }
    }
}

// MARK: - objc private methods

@objc private extension HomeViewController {
    func addPerson() {
        let viewController = EnterDataViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    // begin changed data in db
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // end changed data in db
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath, let person = fetchResultController.object(at: indexPath) as? Person {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = "\(person.name ?? "") - \(person.age)"
            }
        }
    }
}
