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
    
    var ref: DatabaseReference {
        return Database.database().reference()
    }
}
