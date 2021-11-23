//
//  DatabaseManager.swift
//  ShoppingListWithFirebase
//
//  Created by Анна Шанидзе on 22.11.2021.
//

import Foundation
import Firebase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let database = Database.database().reference(withPath: "users")
    
    /// Insert new user to DB
    public func insertNewUser(with email: String, user: AuthDataResult?, completion: @escaping (Bool) -> Void) {
        database.child((user?.user.uid)!).setValue(["email" : user?.user.email]) { error, _ in
            if error == nil {
                // succeeded
                completion(true)
                print("insert")
                return
            } else {
                // failed
                completion(false)
                return
            }
            
        }
    }
    
}
