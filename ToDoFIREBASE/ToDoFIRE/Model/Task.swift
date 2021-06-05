//
//  Task.swift
//  ToDoFIRE
//
//  Created by Sabir Myrzaev on 05.06.2021.
//

import Foundation
import Firebase

struct Task {
    
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed: Bool = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    // snapshot хранение данных в этот момент состящий из JSON
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionate() -> Any {
        return ["title": title, "userId": userId, "completed": completed]
    }
}
