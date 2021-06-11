//
//  ViewController.swift
//  Checklist
//
//  Created by Sabir Myrzaev on 10.06.2021.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items = [ChecklistItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadChecklistItems()
        
        print(dataFilePath())
    }
    
    // MARK: - Load&Save Func
    func saveChecklistItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            // кодирует массив items который можно записать в файл
            let data = try encoder.encode(items)
            // записываем данные в файл, используя путь к файлу
            try data.write (to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadChecklistItems() {
        // помещаем результаты в path
        let path = dataFilePath()
        // пробуем выгрузить данные в новый объект
        if let data = try? Data(contentsOf: path) {
        // если файл Checklists.plist найден, вы загрузите всё в массив и создаем экземпляр декодера
            let decoder = PropertyListDecoder()
            do {
                // загружаем сохранненые данные, первый передаваемый параметр decode
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - config Function
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            // получаем уведомление когда пользователь нажимает отмена или готово
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
        
        let item = items[indexPath.row]
        item.checked.toggle()
        
        configureCheckmark(for: cell, with: item)
    }
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }
    
    // MARK: - Delegate
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func  addItemViewController (_ контроллер: ItemDetailViewController, didFinishEdititng item: ChecklistItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    // MARK: - Путь к папке сохранения
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
}


