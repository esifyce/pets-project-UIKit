//
//  Person+CoreDataProperties.swift
//  CoreDataExamole
//
//  Created by Krasivo on 25.11.2023.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?

}

extension Person : Identifiable {

}
