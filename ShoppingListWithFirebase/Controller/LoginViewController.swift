//
//  ViewController.swift
//  ShoppingListWithFirebase
//
//  Created by Анна Шанидзе on 06.10.2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    let segueIdentifier = "listSegue"
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warnLabel.alpha = 0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passwordTF.text = ""
        emailTF.text = ""
    }
    
    //MARK: - Keyboard
    
    // Adjust a UIScrollView to fit the keyboard
    @objc func kbDidShow(notification: Notification) {
        guard let keyboardValue = notification.userInfo else { return }
        let kbFrameSize = (keyboardValue[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: kbFrameSize.height,
            right: 0)
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height)
    }
    
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: - Warning
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
        
    }
    
    //MARK: - Log In
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTF.text,
              let password = passwordTF.text,
              email != "", password != "" else {
                  displayWarningLabel(withText: "Enter correct data")
                  return
              }
        
        AuthManager.shared.logIn(withEmail: email, password: password) {  [weak self] success in
            if success {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            } else {
                self?.displayWarningLabel(withText: "Error")
            }
        }
        
    }
    
    //MARK: - Register
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
}
