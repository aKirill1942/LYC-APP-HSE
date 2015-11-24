//
//  ContactInfoViewController.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 20.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit

class ContactInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.becomeFirstResponder()
        emailField.delegate = self
        usernameField.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
            
        case emailField:
            self.view.endEditing(true)
            usernameField.becomeFirstResponder()
        case usernameField:
            
            self.view.endEditing(true)
            continueRegistration()

        default: break
        }
        
        return false
    }

    func continueRegistration() {
        if emailField.text != nil && emailField.text != "" && usernameField.text != nil && usernameField.text != "" {
            email = emailField.text!
            login = usernameField.text!
            self.performSegueWithIdentifier("askForPassword", sender: nil)
        } else {
            UIAlertView(title: "Ошибка", message: "Все поля должны быть заполнены!", delegate: self, cancelButtonTitle: "OK").show()
            emailField.becomeFirstResponder()
        }
        
    }
    
    @IBAction func nextPressed() {
        continueRegistration()
    }

}
