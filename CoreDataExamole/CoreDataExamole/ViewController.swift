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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // create context
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        // create description entity
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        // create object
        //let managedObject = NSManagedObject(entity: entityDescription!, insertInto: context)
        
        // set data in attribute
//        managedObject.setValue("Vlad", forKey: "name")
//        managedObject.setValue(38, forKey: "age")
        
        // get data from attribute
//        let name = managedObject.value(forKey: "name")
//        let age = managedObject.value(forKey: "age")
        
        // create object
        let managedObject = Person(entity: entityDescription!, insertInto: context)
        
        // set data in attribute
        
        managedObject.name = "Оля"
        managedObject.age = 39
        
        let name = managedObject.name
        let age = managedObject.age
     
        
        print("\(name) - \(age)")
        
        // save data
        appDelegate.saveContext()
        
        // get data from db
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            let results = try context.fetch(fetchRequest)
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
            let results = try context.fetch(fetchRequest)
            results.forEach { result in
                if let result = result as? NSManagedObject {
                    context.delete(result)
                } else if let result = result as? Person {
                    context.delete(result)
                }
            }
        } catch {
            print(error)
        }
        
        // get data from db
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { result in
                if let result = result as? NSManagedObject {
                    print("name - \(result.value(forKey: "name")), age - \(result.value(forKey: "age"))")
                }
            }
        } catch {
            print(error)
        }
        
        // save data
        appDelegate.saveContext()
    }


}

