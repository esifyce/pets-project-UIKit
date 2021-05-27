//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sabir Myrzaev on 27.05.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // массив собственных объектов
      var categories = [Category]()
    
    // подключение к AppDelegate через @UIApplication чтобы создавать, читать, обновлять и уничтожать CRUD
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // получение данных из CoreData
        loadItems()
    }
    
    // MARK: - TableView Datasource Methods
    // заполнение данных
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // удалить из очереди повторно используемую ячейку с индификатором indexPath
        // таким образом создает многоразовую ячейку и добавляет ее в таблицу по пути к индексу
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
        
        // MARK: - TableView Delegate Methods
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    // MARK: - Data Manipulation Methods
    
    // MARK: - Save Items
    func saveCategories() {
         
         do {
            try context.save()
         } catch {
             print("Error encoding item array, \(error)")
         }
         
         self.tableView.reloadData()
    }
    
    // MARK: - Load items
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

    
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // текст всплывающего окошко
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // кнопка всплывающего окна
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // добавление Item в CoreData - CREATE in CoreData(Crud)
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            //newItem.done = false
            
            // добавляет элемент при нажатии кнопки
            self.categories.append(newCategory)
            
            self.saveCategories()
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
