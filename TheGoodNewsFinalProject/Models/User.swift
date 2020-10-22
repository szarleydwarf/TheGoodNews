//
//  User.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 22/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation

class User {
    
    var email:String?
    var name:String?
    var isSigned:Bool = false
    let userDefaults = UserDefaults.standard
    let stringEmail = "email"
    
    func getUserEmail() -> String? {
        return userDefaults.string(forKey: stringEmail)
    }
    
    func isUserSigned() {
        if let email = self.email {
            do {
                let password = try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email).readPassword()
                self.isSigned =  password.count > 0 ? true : false
            } catch {
                self.isSigned = false
            }
        }
    }
    
    func getUserName() {
        if let email = self.email {
            let userNameArray = email.components(separatedBy: "@")
            self.name  = userNameArray[0]
        }
    }
    
    init() {
        self.email = self.getUserEmail()
        isUserSigned()
        getUserName()
    }
}
