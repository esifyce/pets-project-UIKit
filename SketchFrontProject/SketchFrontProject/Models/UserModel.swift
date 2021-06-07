//
//  UserModel.swift
//  SketchFrontProject
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import UIKit

class ContactsModel {
    
    enum CornerDirections: Int, Codable {
        case top, all, bottom, nope
    }
    
    struct User: Hashable, Decodable {
        var fullname: String
        var imageString: String
        var firstCharacter: String
        var id: Int
        var direction: CornerDirections?
        
        // сравнивать юзеров по id
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    enum SectionType: Int {
        case profile
        case fovourites
        case contacts
    }
    
    struct UserCollection: Hashable {
        var type: SectionType
        var header: String?
        var users: [User]
        var id = UUID()
        
        // сравнивать юзеров по id
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
    var collections: [UserCollection] {
        return _collection
    }
    
    init() {
        generateCollections()
    }
        fileprivate var _collection = [UserCollection]()
}

extension ContactsModel {
    
    func generateCollections() {
        let profile = User(fullname: "Alexey Parkhomenko", imageString: "human1", firstCharacter: "A", id: 20)
        let favouriteUsers = Bundle.main.decode([User].self, from: "favouriteUsers.json")
        let contactsUsers = Bundle.main.decode([User].self, from: "contactUsers.json")
        
        _collection = [
            UserCollection(type: .profile, header: nil, users: [profile]),
            UserCollection(type: .fovourites, header: nil, users: favouriteUsers)
        ]
        
        var dict: [String: [User]] = [:]
        contactsUsers.forEach { user in
            if dict[user.firstCharacter] == nil {
                dict[user.firstCharacter] = [user]
            } else {
                if dict[user.firstCharacter]?.first?.firstCharacter == user.firstCharacter {
                    dict[user.firstCharacter]?.append(user)
                }
            }
        }
        
        dict.forEach { (key, users) in
            _collection.append(UserCollection(type: .contacts, header: key, users: users))
        }
    }
}
