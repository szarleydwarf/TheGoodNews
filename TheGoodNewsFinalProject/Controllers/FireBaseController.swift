//
//  FireBaseController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 24/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import Firebase

class FireBaseController{
    private init(){}
    
    static let shared = FireBaseController()
    
    var fAuth: Auth{
        return Auth.auth()
    }
    
    var refRoot: DatabaseReference {
        return Database.database().reference()
    }
    
    var refUsers:DatabaseReference {
        return Database.database().reference(withPath: "users")
    }
    var refFavQuotes:DatabaseReference {
        return Database.database().reference(withPath: "favQoutes")
    }
    var refFavPoems:DatabaseReference {
        return Database.database().reference(withPath: "favPoems")
    }
    var refuserTexts:DatabaseReference {
        return Database.database().reference(withPath: "userTexts")
    }
}
