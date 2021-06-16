//
//  Category.swift
//  ToDoRealm
//
//  Created by Sabir Myrzaev on 16.06.2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // создаем связь, каждая категория имеет список элементов
    var items = List<Item>()
}
