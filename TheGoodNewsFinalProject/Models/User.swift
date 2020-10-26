//
//  User.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 26/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation

class User {
    private init(){}
    static let shared = User()
    
    var email:String = ""
    var name:String = ""
}
