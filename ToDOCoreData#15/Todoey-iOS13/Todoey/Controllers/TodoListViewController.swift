//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    // массив собственных объектов
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            // получение данных из CoreData
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // подключение к AppDelegate через @UIApplication
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
// MARK: - TableView Datasource Methods
   
    // заполнение данных
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
    // ставит и убирает галочку на выбронную строку
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
// MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // UPDATE in Core data (crUd)
        //itemArray[indexPath.row].setValue("Complete", forKey: "title")
        
        // удаление элемента Destroy in CoreData (cruD)
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // галочка на задаче
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        
        // убирает серый цвет с ячейки, когда кликаешь
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // текст всплывающего окошко
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        // кнопка всплывающего окна
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // добавление Item в CoreData - CREATE in CoreData(Crud)
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            // добавляет элемент при нажатии кнопки
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        // добавление текстового поля в окошко
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Save Items
    func saveItems() {
         
         do {
            try context.save()
         } catch {
             print("Error encoding item array, \(error)")
         }
         
         self.tableView.reloadData()
    }
    // MARK: - Load items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            // отфильтровывает
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

    // MARK: - UISearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          // чтение из CoreData; READ in CoreData (cRud)
        // создаем запрос
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // как мы делаем запрос title который содержит текст который мы ввели в SearchBar
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // сортировка в алфавитном порядке
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    // отвечает за введеные буквы в поиске, и когда строка пуста, будет отображать все в массиве
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                // при исчезновении курсора убирает клавиатуру
                searchBar.resignFirstResponder()
            }
        }
    }
}
