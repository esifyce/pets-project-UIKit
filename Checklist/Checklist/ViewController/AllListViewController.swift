//
//  AllListViewController.swift
//  Checklist
//
//  Created by Sabir Myrzaev on 12.06.2021.
//

import UIKit

// показывает все списки пользователей.
class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

 //     tableView.register (UITableViewCell.self , forCellReuseIdentifier: cellIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true

//        for list in dataModel.lists {
//            let item = ChecklistItem()
//            list.items.append(item)
//        }
        
    }
    // UIKit автоматически вызывает этот метод после того, как контроллер представления становится видимым.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    // вызывается раньше viewDidAppear(), когда представление должно стать видимым, но анимация еще не началась
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            // всегда ожидает Checklist объект 
            controller.checklist = sender as? ChecklistData
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // получить ячейку
        let cell: UITableViewCell
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        // обновляем информацию о ячейке
        let checklist = dataModel.lists[indexPath.row]
        cell.accessoryType = .detailDisclosureButton
        
        if let label = cell.textLabel {
            label.text = checklist.name
        }
        
        if let label = cell.detailTextLabel {
            let count = checklist.countUncheckedItems()
            if checklist.items.count == 0 {
                label.text = "No items"
            } else {
            label.text = count == 0 ? "All done" : "Remining \(count)"
        }
    }
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        return cell
}
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(identifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
        
    }
}
// MARK: - ListDetailVC delegate
extension AllListsViewController: ListDetailViewControllerDelegate {
    // MARK: - ListDetail delegate
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: ChecklistData) {
//        let newRowIndex = dataModel.lists.count
//        dataModel.lists.append(checklist)
//
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
//
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: ChecklistData) {
//        if let index = dataModel.lists.firstIndex(of: checklist) {
//            let indexPath1 = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath1) {
//                cell.textLabel!.text = checklist.name
//            }
//        }
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UINavigationController delegate
extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
