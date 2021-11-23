//
//  Item.swift
//  ShoppingListWithFirebase
//
//  Created by Анна Шанидзе on 07.10.2021.
//

import Foundation
import Firebase

struct Item {
    
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> [String : Any] {
        return ["title" : title, "userId" : userId, "completed" : completed]
    }
    
}
