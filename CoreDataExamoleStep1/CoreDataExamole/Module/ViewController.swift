//
//  ViewController.swift
//  CoreDataExamole
//
//  Created by Krasivo on 25.11.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        
        
        let managedObject = Person()
        
        // set data in attribute
        
        managedObject.name = "Оля"
        managedObject.age = 39
        
        let name = managedObject.name
        let age = managedObject.age
     
        
        print("\(name) - \(age)")
        
        // save data
        CoreDataManager.instance.saveContext()
        
        // get data from db
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            let results = try CoreDataManager.instance.context.fetch(fetchRequest)
            results.forEach { result in
//                if let result = result as? NSManagedObject {
//                    print("name - \(result.value(forKey: "name")), age - \(result.value(forKey: "age"))")
//                }
                
                if let result = result as? Person {
                    print("name - \(result.name), age - \(result.age)")
                }
            }
        } catch {
            print(error)
        }
        
        // remove all notes
        
        do {
            let results = try CoreDataManager.instance.context.fetch(fetchRequest)
            results.forEach { result in
                if let result = result as? Person {
                    CoreDataManager.instance.context.delete(result)
                }
            }
        } catch {
            print(error)
        }
        
        // save data
        CoreDataManager.instance.saveContext()
    }


}

