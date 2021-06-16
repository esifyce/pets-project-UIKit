//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sabir Myrzaev on 27.05.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // массив собственных объектов
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // получение данных из Realm
        loadCategories()
    }
    
    // MARK: - TableView Datasource Methods
    // заполнение данных
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // удалить из очереди повторно используемую ячейку с индификатором indexPath
        // таким образом создает многоразовую ячейку и добавляет ее в таблицу по пути к индексу
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category"
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    // MARK: - Data Manipulation Methods
    
    // MARK: - Save Items
    func save(category: Category) {
        
        // сохраняем категорию в нашем контейнере Realm с помощью .write
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
//     MARK: - Load items
        func loadCategories() {
            
            categories = realm.objects(Category.self)
    
        }
    
    
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // текст всплывающего окошко
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // кнопка всплывающего окна
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // добавление Item в CoreData - CREATE in CoreData(Crud)
            let newCategory = Category()
            
            newCategory.name = textField.text!
            //newItem.done = false
    
            self.save(category: newCategory)
        }
        // добавление текстового поля в окошко
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
