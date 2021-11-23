//
//  ListViewController.swift
//  ShoppingListWithFirebase
//
//  Created by Анна Шанидзе on 06.10.2021.
//

import UIKit
import Firebase

class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User!
    var ref: DatabaseReference!
    var items = Array<Item>()

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser = Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("items")

        ref.observe(.value) { [weak self] (snapshot) in
            var items = [Item]()
            for child in snapshot.children {
                let item = Item(snapshot: child as! DataSnapshot)
                items.append(item)
            }
            self?.items = items
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Toggle completion
    
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New item", message: "Add new item", preferredStyle: .alert)
        alertController.addTextField()
        
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
    
            let item = Item(title: textField.text!, userId: (self?.user.uid)!)
            let itemRef = self?.ref.child(item.title.lowercased())
            itemRef?.setValue(item.convertToDictionary())
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Sign Out
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        AuthManager.shared.logOut { success in
            if success {
                dismiss(animated: true, completion: nil)
            }
        }
    }
}


    // MARK: - TableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = .black
        
        let item = items[indexPath.section]
        cell.textLabel?.text = item.title
        
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        toggleCompletion(cell, isCompleted: item.completed)
        return cell
    }
    
    //MARK: - Delete items
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.section]
            item.ref?.removeValue()
        }
    }
    
}


    // MARK: - TableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let item = items[indexPath.section]
        let isCompleted = !item.completed
        
        item.ref?.updateChildValues(["completed" : isCompleted])
        toggleCompletion(cell, isCompleted: isCompleted)

    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
