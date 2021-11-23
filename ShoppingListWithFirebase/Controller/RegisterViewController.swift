//
//  RegisterViewController.swift
//  ShoppingListWithFirebase
//
//  Created by Анна Шанидзе on 23.11.2021.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTF.text,
              let password = passwordTF.text,
              email != "", password != "" else {
                  displayWarningLabel(withText: "Enter correct data")
                  return
              }
        
        AuthManager.shared.register(password: password, email: email) { [weak self] success in
            if !success {
                self?.displayWarningLabel(withText: "Error")
            }
        }
    }
    
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
        
    }
}
