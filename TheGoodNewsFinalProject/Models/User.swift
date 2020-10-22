//
//  User.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 22/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation

class User {
    let userDefaults = UserDefaults.standard
    let stringEmail = "email"
    
    var email:String = "Unknown@Unknown.org"
    var name:String?
    var isSigned:Bool = false
    
    func setUserInUserDefaults(email: String) {
        self.userDefaults.set(email, forKey: self.stringEmail)
    }
    
    func getUserEmail() -> String? {
        return userDefaults.string(forKey: stringEmail)
    }
    
    func isUserSigned() {
        do {
            let password = try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: self.email).readPassword()
            self.isSigned =  password.count > 0 ? true : false
        } catch {
            self.isSigned = false
        }
    }
    
    func getUserName() {
        let userNameArray = email.components(separatedBy: "@")
        self.name  = userNameArray[0]
    }
    
    init() {
        self.email = self.getUserEmail() ?? "Unknown@Unknown.org"
        isUserSigned()
        getUserName()
    }
}
