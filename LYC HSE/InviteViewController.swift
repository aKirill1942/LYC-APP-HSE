//
//  InviteViewController.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 18.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit
import Alamofire

class InviteViewController: UIViewController {

    // Outlets declarations
    @IBOutlet weak var inviteField: UITextField!
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    
    // Create activity indicator
    let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 20, 20))
    
    
    // Overriding default viewDidLoad() method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inviteField.becomeFirstResponder()
    }
    
    
    // A method used to limit symbols user is able to type
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var result = true
        
        if textField == inviteField {
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = NSCharacterSet(charactersInString: "0123456789").invertedSet
                let replacementStringIsLegal = string.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
                result = replacementStringIsLegal
            }
        }
        
        return result
    }
    
    
    // Called when the app stops connection to the server
    func stopActivityIndicator() {
        
        // Enable 'invisible' text field and 'Cancel' button
        inviteField.userInteractionEnabled = true
        cancelButton.enabled = true
        
        // Show keyboad and hide activity indicator
        inviteField.becomeFirstResponder()
        activityIndicator.stopAnimating()
        
    }
    
    
    // Called when the app starts connection to the server
    func startActivityIndicator() {
        
        // Create bar item and start the activity indicator
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButtonItem(barButton, animated: true)
        activityIndicator.startAnimating()
        
        // Disable 'invisible' text field and 'Cancel' button
        inviteField.userInteractionEnabled = false
        cancelButton.enabled = false
        
    }
    
    
    // Called when 'Cancel' button is pressed
    @IBAction func canceled(sender: UIBarButtonItem) {
        
        // Make status bar black and dissmis registration
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Called when text field changes
    @IBAction func didChanged(sender: UITextField) {
        
        // Switch to update the label
        switch sender.text!.characters.count {
        case 0:
            inviteLabel!.text = inviteField.text!
        case 1:
            inviteLabel!.text = inviteField.text!
        case 2:
            inviteLabel!.text = inviteField.text!
        case 3:
            inviteLabel!.text = inviteField.text!
        case 4:
            inviteLabel!.text = inviteField.text!
        case 5:
            inviteLabel!.text = inviteField.text!
        case 6:
            inviteLabel!.text = inviteField.text!
        case 7:
            inviteLabel!.text = inviteField.text!
        case 8:
            inviteLabel!.text = inviteField.text!
        case 9:
            inviteLabel!.text = inviteField.text!
        case 10:
            inviteLabel!.text = inviteField.text!
            
            // Freeze the interface
            startActivityIndicator()
        
            // Start connection
            Alamofire.request(.POST, "http://lyceum.styleru.net/app/api/InviteCheck", parameters: ["invite": inviteField.text!]) .responseJSON { response in
                
                // Check the response
                if let JSON = response.result.value {
                    
                    // Check the error code
                    let code = JSON["error_code"]
                    if code as! String == "00" {
                        
                        inviteCode = self.inviteField.text!
                        // Unfreeze the interface and go th the next screen
                        self.stopActivityIndicator()
                        self.performSegueWithIdentifier("continueReg", sender: self)

                    } else {

                        switch code as! String {
                        case "02":
                            // Alert user about the problem and stop the connectiom
                            showSimpleAlertWithTitle("Ошибка", messageText: "Введенный пригласительный код уже зарегестрирован.", buttonText: "OK")
                        case "09":
                            showSimpleAlertWithTitle("Ошибка", messageText: "Введенный пригласительный код не существует.", buttonText: "OK")
                        default:
                            break
                        }
                            self.stopActivityIndicator()
                            self.inviteLabel.text = ""
                            self.inviteField!.text = ""
                            self.inviteField.becomeFirstResponder()
                    }
                    
                } else {
                    
                    // Alert user about the problem and stop the connectiom
                    showSimpleAlertWithTitle("Проблемы с подключением", messageText: "Убедитесь, что вы подключены к сети Интернет и повторите попытку.", buttonText: "OK")
                    self.stopActivityIndicator()
                    self.inviteLabel.text = ""
                    self.inviteField!.text = ""
                    self.inviteField.becomeFirstResponder()

                }
            }

        default: break
        }

        
    }
    

    
    
}
