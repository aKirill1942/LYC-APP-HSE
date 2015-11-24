//
//  ViewController.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 29.08.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
    
    // Outlets declarations
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintUsername: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintLogin: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintRegister: NSLayoutConstraint!
    @IBOutlet weak var topSeparator: UIImageView!
    @IBOutlet weak var bottomSeparator: UIImageView!
    @IBOutlet weak var usernameImage: UIImageView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // Current keyboard state
    var keyboardIsActive = false
    
    
    // Deinitializer of the ViewController
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    
    // Overriding default viewDidLoad() method
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding observers to monitor keyboard current state
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        // Set delegates
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    
    // User touches background of the view
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        
        // Hide keyboard
        view.endEditing(true)
        
        // Call superclass method
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    // Called when keyboard is shown
    func keyboardWillShow(notification: NSNotification) {
        
        // Notofication variable
        var info = notification.userInfo!
        
        // Detect keyboard frame
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        // Check keyboard current state
        if !keyboardIsActive {
            
            // Animate text fields
            moveFieldsUp(keyboardFrame)
        }
        
        // Change keyboard current state
        keyboardIsActive = true
    }

    
    // Called when keyboard is hidden
    func keyboardWillHide(notification: NSNotification) {
        
        // Notofication variable
        var info = notification.userInfo!
        
        // Detect keyboard frame
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        // Return text field to start position
        moveFieldsDown(keyboardFrame)
        
        // Change keyboard current state
        keyboardIsActive = false
    }
    
    
    // Called when 'Register' button is pressed
    @IBAction func registerButtonPressed(sender: UIButton) {
        
        // Make statusbar white
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        // Segue to the registration (segue is declared on the storyboard)
    }
    
    
    // Called when 'Login' button is pressed
    @IBAction func loginButtonPressed() {
        
        logUserIn()
        // Make statusbar white
        
        
    }
    
    // Text fields move up animation
    func moveFieldsUp(keyboardFrame: CGRect) {
        self.usernameField.center.y -= 100
        UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations: {
            self.logoImage.alpha = 0.0
            self.welcomeLabel.alpha = 0.0
            self.usernameField.center.y -= keyboardFrame.size.height
            self.passwordField.center.y -= keyboardFrame.size.height
            self.topSeparator.center.y -= keyboardFrame.size.height
            self.bottomSeparator.center.y -= keyboardFrame.size.height
            self.usernameImage.center.y -= keyboardFrame.size.height
            self.passwordImage.center.y -= keyboardFrame.size.height
            self.loginButton.center.y -= keyboardFrame.size.height
            self.registerButton.center.y -= keyboardFrame.size.height
            self.bottomConstraint.constant = keyboardFrame.size.height + self.passwordField.frame.height + 128 + 38
            self.bottomConstraintUsername.constant = keyboardFrame.size.height + 148
            self.bottomConstraintLogin.constant = keyboardFrame.size.height + 42 + 30
            self.bottomConstraintRegister.constant = keyboardFrame.size.height + 20
        }, completion: nil)
    }
    
    
    // Text fields move down animation
    func moveFieldsDown(keyboardFrame: CGRect) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseOut], animations: {
            self.bottomConstraintLogin.constant = 79
            self.logoImage.alpha = 1.0
            self.welcomeLabel.alpha = 1.0
            self.logoImage.center.y -= 100
            self.welcomeLabel.center.y -= 100
            self.usernameField.center.y += keyboardFrame.size.height
            self.passwordField.center.y += keyboardFrame.size.height
            self.topSeparator.center.y += keyboardFrame.size.height
            self.bottomSeparator.center.y += keyboardFrame.size.height
            self.usernameImage.center.y += keyboardFrame.size.height
            self.passwordImage.center.y += keyboardFrame.size.height
            self.loginButton.center.y += keyboardFrame.size.height
            self.registerButton.center.y += keyboardFrame.size.height
            self.bottomConstraint.constant = 193
            self.bottomConstraintUsername.constant = 154
            self.bottomConstraintRegister.constant = 29
            }, completion: nil)
    }
    
    func logUserIn() {
        if usernameField.text != nil && usernameField.text! != "" && passwordField.text != nil && passwordField.text! != "" {
            
            hideAndAnimate()
            Alamofire.request(.POST, "http://lyceum.styleru.net/app/api/Auth", parameters: ["login": usernameField.text!, "password": passwordField.text!]) .responseJSON { response in
                if let JSON = response.result.value {
                    if JSON["error_code"] as! String == "00" {
                        
                        self.usernameField.text = ""
                        self.passwordField.text = ""
                        self.showAndStop()
                        defaults.setObject(JSON["email"] as! String, forKey: "email")
                        defaults.setInteger(JSON["id"] as! Int, forKey: "id")
                        defaults.setObject(JSON["lastname"] as! String, forKey: "lastname")
                        defaults.setObject(JSON["name"] as! String, forKey: "name")
                        defaults.setObject(JSON["photourl"] as! String, forKey: "photourl")
                        defaults.setObject(JSON["soc_group_id"] as! Int, forKey: "soc_group_id")
                        defaults.setObject(JSON["surname"] as! String, forKey: "surname")
                        defaults.setObject(JSON["token"] as! String, forKey: "token")
                        defaults.setObject(JSON["year_id"] as! Int, forKey: "year_id")
                        self.dismissViewControllerAnimated(true, completion: nil)

                    } else {
                        UIAlertView(title: "Ошибка", message: "Неверный логин или пароль.", delegate: self, cancelButtonTitle: "OK").show()
                        self.showAndStop()
                    }
                } else {
                    UIAlertView(title: "Ошибка", message: "Проверьте соединение с Интернетом.", delegate: self, cancelButtonTitle: "OK").show()
                    self.showAndStop()
                }
            }
        }

    }
    
    func hideAndAnimate() {
        welcomeLabel.hidden = true
        activityIndicator.startAnimating()
        usernameField.userInteractionEnabled = false
        passwordField.userInteractionEnabled = false
        loginButton.enabled = false
        registerButton.enabled = false
    }
    
    func showAndStop() {
        welcomeLabel.hidden = false
        activityIndicator.stopAnimating()
        usernameField.userInteractionEnabled = true
        passwordField.userInteractionEnabled = true
        loginButton.enabled = true
        registerButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
            
        case usernameField:
            self.view.endEditing(true)
            passwordField.becomeFirstResponder()
        case passwordField:
            
            self.view.endEditing(true)
            logUserIn()
            
        default: break
        }
        
        return false
    }

}
