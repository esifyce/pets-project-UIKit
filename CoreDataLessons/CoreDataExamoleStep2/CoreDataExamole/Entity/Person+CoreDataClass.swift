//
//  Person+CoreDataClass.swift
//  CoreDataExamole
//
//  Created by Krasivo on 25.11.2023.
//
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entitityName: "Person"), insertInto: CoreDataManager.instance.context)
    }
}
