//
//  PasswordViewController.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 20.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit
import Alamofire

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var finishRegistrationButton: UIButton!
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 20, 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.delegate = self
        confirmPasswordField.delegate = self
        passwordField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
            
        case passwordField:
            self.view.endEditing(true)
            confirmPasswordField.becomeFirstResponder()
        case confirmPasswordField:
            
            self.view.endEditing(true)
            completeRegistration()
            
        default: break
        }
        
        return false
    }

    
    @IBAction func finishRegistration() {
        completeRegistration()
    }

    func completeRegistration() {
        if passwordField.text != nil && passwordField.text != "" && confirmPasswordField.text != nil && confirmPasswordField.text != "" {
            if passwordField.text == confirmPasswordField.text {
                password = passwordField.text!
                let data = [
                    "email": email,
                    "invite": inviteCode,
                    "login": login,
                    "password": password
                ]
                print(data)
                let barButton = UIBarButtonItem(customView: activityIndicator)
                self.navigationItem.setRightBarButtonItem(barButton, animated: true)
                activityIndicator.startAnimating()
                
                passwordField.userInteractionEnabled = false
                confirmPasswordField.enabled = false
                finishRegistrationButton.enabled = false
                self.navigationItem.setHidesBackButton(true, animated: true)
                
                Alamofire.request(.POST, "http://lyceum.styleru.net/app/api/Reg", parameters: ["email": email, "invite": inviteCode, "login": login, "password": password]) .responseJSON { response in
                    print(response)
                    if let JSON = response.result.value {
                        print(JSON)
                        let code = JSON["error_code"]
                        switch code as! String {
                        case "00":
                            UIAlertView(title: "Готово", message: "Регистрация прошла успешно! Теперь Вы можете использовать свой логин и пароль для входа в приложение.", delegate: self, cancelButtonTitle: "OK").show()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        case "01":
                            UIAlertView(title: "Ошибка", message: "Данный email уже зарегистрирован.", delegate: self, cancelButtonTitle: "OK").show()
                            self.stopIndicator()
                        case "08":
                            UIAlertView(title: "Ошибка", message: "Данный логин уже занят.", delegate: self, cancelButtonTitle: "OK").show()
                            self.stopIndicator()
                        default:
                            UIAlertView(title: "Ошибка", message: "Ошибка регистрации. Повторите попытку.", delegate: self, cancelButtonTitle: "OK").show()
                            self.stopIndicator()
                        }
                    } else {
                        UIAlertView(title: "Ошибка", message: "Проверьте соединение с Интернетом.", delegate: self, cancelButtonTitle: "OK").show()
                        self.passwordField.becomeFirstResponder()
                        self.stopIndicator()
                    }
                }
            } else {
                UIAlertView(title: "Ошибка", message: "Пароли не совпадают!", delegate: self, cancelButtonTitle: "OK").show()
                passwordField.becomeFirstResponder()
                stopIndicator()
            }
        } else {
            UIAlertView(title: "Ошибка", message: "Все поля должны быть заполнены!", delegate: self, cancelButtonTitle: "OK").show()
            passwordField.becomeFirstResponder()
            stopIndicator()
        }

    }
    
    func stopIndicator() {
        
        activityIndicator.stopAnimating()
        
        passwordField.userInteractionEnabled = true
        confirmPasswordField.enabled = true
        finishRegistrationButton.enabled = true
        self.navigationItem.setHidesBackButton(false, animated: true)
        passwordField.becomeFirstResponder()
    }

}
