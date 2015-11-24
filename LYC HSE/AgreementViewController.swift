//
//  AgreementViewController.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 19.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AgreementViewController: UIViewController, MFMailComposeViewControllerDelegate {
    

    @IBOutlet weak var agreementText: UITextView!
    
    var fullTitle = ""
    var fullText = dataAgreement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if typeOfAgreement == "data" {
            self.title = "Согласие на обработку"
            fullTitle = "Согласие на обработку персональных данных LYC APP"
        } else {
            self.title = "Условия пользования"
            fullTitle = "Условия использования приложения LYC APP"
        }
        

        agreementText.text = fullText
        agreementText.font = UIFont(name: "Helvetica Neue Light", size: 17)
        agreementText.textColor = UIColor.grayColor()
        agreementText.setContentOffset(CGPointZero, animated: true)
    }
    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func sendByMail(sender: UIBarButtonItem) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setSubject(fullTitle)
        mailComposerVC.setMessageBody(fullText, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Невозможно отправить", message: "Проверьте настройки электронной почти и попробуйт снова.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
