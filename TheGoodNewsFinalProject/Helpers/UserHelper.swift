//
//  UserHelper.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 26/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class UserHelper {
    
    func userExistInKeyChain(email:String) -> Bool {
        do {
            let password = try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email).readPassword()
            return  password.count > 0 ? true : false
        } catch {
            return false
        }
    }
    
    func saveUserToKeyChain(view:UIView, email:String, password:String) {
        var hashedPassword = hashThePassword(from: email, password: password)
        do {
            let paswordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email)
            try paswordItem.savePassword(hashedPassword)
        } catch let error{
            Toast().showToast(message: "\(Constants.error.userProfileCreationKeyChain) \(error)", font: .systemFont(ofSize: 16), view: view)
        }
    }
    
    func hashThePassword(from email: String, password: String) -> String {
        let salt = "x4vV8bGgqqmQw974yriksdbckbq9ipidk;jgCoyXFQj+(o.nP7ND"
        return "\(password).\(email).\(salt)".sha256()
    }
    
    func getUserName(email:String) ->String {
        let userNameArray = email.components(separatedBy: "@")
        return userNameArray[0]
    }
    
}
