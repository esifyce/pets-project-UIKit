//
//  User.swift
//  ToDoFIRE
//
//  Created by Sabir Myrzaev on 05.06.2021.
//

import Foundation
import Firebase

struct UserModel {
    
    let uid: String
    let email: String
    
    // извлчеть индифактор польщователя и его email для того чтобы работать с ними локально
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
