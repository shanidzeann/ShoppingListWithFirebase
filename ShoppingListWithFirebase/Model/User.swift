//
//  User.swift
//  ShoppingListWithFirebase
//
//  Created by Анна Шанидзе on 07.10.2021.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email!
    }
    
}
