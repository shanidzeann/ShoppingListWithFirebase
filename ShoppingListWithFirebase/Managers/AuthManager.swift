//
//  AuthManager.swift
//  ShoppingListWithFirebase
//
//  Created by Анна Шанидзе on 22.11.2021.
//

import Foundation
import Firebase

class AuthManager {
    
    static let shared = AuthManager()
    
    func logIn(withEmail email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard error == nil, authResult != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
        
    }
    
    func register(password: String, email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            guard error == nil, user != nil else {
                completion(false)
                print(error!)
                return
            }
            DatabaseManager.shared.insertNewUser(with: email, user: user) { inserted in
                if inserted {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print(error)
            completion(false)
            return
        }
    }
    
}
