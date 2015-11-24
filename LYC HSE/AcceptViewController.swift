//
//  AcceptViewController.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 19.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit

class AcceptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

     @IBAction func showData(sender: UIButton) {
        typeOfAgreement = "data"
        performSegueWithIdentifier("showAgreement", sender: sender)
    }

    @IBAction func showAgreement(sender: UIButton) {
        typeOfAgreement = "terms"
        performSegueWithIdentifier("showAgreement", sender: sender)
    }

    

}
