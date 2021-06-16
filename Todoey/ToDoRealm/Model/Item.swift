//
//  Item.swift
//  ToDoRealm
//
//  Created by Sabir Myrzaev on 16.06.2021.
//

import Foundation
import RealmSwift

class Item: Object {
    // позволяет отслеживать изменения
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var done: Bool = false
    // каждый элемент имеет родительскую категорию
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
