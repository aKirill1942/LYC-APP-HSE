//
//  serverManager.swift
//  LYC HSE
//
//  Created by Кирилл Аверкиев on 17.11.15.
//  Copyright © 2015 HSE Lyceum. All rights reserved.
//

import UIKit
import Alamofire

class ServerManager: NSObject {
    
    func loginUser(login login: String, password: String) {
        
        let data = [
            "login": login,
            "password": password
        ]
        
        Alamofire.request(.POST, "http://lyceum.styleru.net/app/api/Auth", parameters: data) .responseJSON { response in
            print(response)
        }
    }
    
    func registerUserData(invite invite: String, email: String, login: String, password: String) {
        
        let data = [
            "invite": invite,
            "email": email,
            "login": login,
            "password": password
        ]
        
        Alamofire.request(.POST, "http://lyceum.styleru.net/app/api/Reg", parameters: data) .responseJSON { response in
            if let JSON = response.result.value {
                print(JSON["error_code"])
            }
        }
    }
    
    func checkInvite(invite: String) {
        
        print("check")
        
        let data = [
            "invite": invite
        ]
        
        Alamofire.request(.POST, "http://lyceum.styleru.net/app/api/InviteCheck", parameters: data) .responseJSON { response in
            if let JSON = response.result.value {
                let code = JSON["error_code"]
                if code as! String == "00" {
                    print("lol")
                }
            }
        }
        
    }
    
}
