//
//  UserPoemsAndQutes.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 18/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class UserPoemsAndQutes {
    let coreDataController = CoreDataController.shared
    
    func fetchUserTexts (view: UIView, userEmail:String="Unknown@Unknown.org")->[UserQuotePoems] {
        var userText:[UserQuotePoems] = []
        let ctx = coreDataController.mainCtx
        let request: NSFetchRequest<UserQuotePoems> = UserQuotePoems.fetchRequest()
        request.predicate = NSPredicate(format: "userEmail = %@", userEmail)
        do{
            userText = try ctx.fetch(request)
        } catch let err {
            Toast().showToast(message: "Failed to fetch your texts \(err.localizedDescription)", font: .systemFont(ofSize: 15), view: view)
        }
        return userText
    }
    
    func saveUserQuoteOrPoem(title:String?, text:String, isQuote:Bool, userEmail:String="Unknown@Unknown.org") -> Bool {
        let context = self.coreDataController.mainCtx
        let userText = UserQuotePoems(context: context)
        
        userText.isQuote = isQuote
        userText.title = title
        userText.text = text
        userText.userEmail = userEmail
        
        return self.coreDataController.save()
    }
    
    func deleteUserText(title:String?, text:String, isQuote:Bool, userEmail:String="Unknown@Unknown.org") -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        if let title = title {
            request.predicate = NSPredicate(format: "text = %@ && title = %@ && isQuote && userEmail = %@", text, title, isQuote, userEmail)
        } else {
            request.predicate = NSPredicate(format: "text = %@ && isQuote && userEmail = %@", text, isQuote, userEmail)
        }
        
        do {
            let result = try mainCtx.fetch(request)
            if result.count > 0 {
                mainCtx.delete(result[0])
            }
        } catch let err {
            print("fetch error \(err)")
        }
        return self.coreDataController.save()
    }
    
    // Firebase Database func's
    let firebaseController = FireBaseController.shared
    
    struct UserText {
        var userTextID:String
        var userEmail:String
        var title:String
        var text:String
        var isQoute:String
        
        var dictionary:[String:Any]{
            return ["userTextID":userTextID,
                    "userEmail":userEmail,
                    "title":title,
                    "text":text,
                    "isQuote":isQoute
            ]
        }
    }
    
    func boolToString(isQoute:Bool) -> String{
        if isQoute {
            return "yes"
        }
        return "no"
    }
    
    func stringToBool(isQoute:String) -> Bool {
        if isQoute == "yes" {
            return true
        }
        return false
    }
    
    func saveIntoFireDataBase(userID:String, userEmail:String, title:String, text:String, isQoute:Bool) {
        if let textID = firebaseController.refuserTexts.child(userID).childByAutoId().key {
            let isQ = boolToString(isQoute: isQoute)
            let text = UserText(userTextID: textID, userEmail: userEmail, title: title, text: text, isQoute: isQ)
            firebaseController.refuserTexts.child(userID).child(textID).setValue(text.dictionary)
        }
    }
    
    func saveIntoFireDataBaseReturnID(userID:String, userEmail:String, title: String, text:String, isQoute:Bool) -> String {
        if let textID = firebaseController.refuserTexts.child(userID).childByAutoId().key {
            let isQ = self.boolToString(isQoute: isQoute)
            let text = UserText(userTextID: textID, userEmail: userEmail, title: title, text: text, isQoute: isQ)
            firebaseController.refuserTexts.child(userID).child(textID).setValue(text.dictionary)
            return textID
        }
        return ""
    }
    
    func fetchFromFireDataBase (userID:String, completion:@escaping(([UserText]))-> Void) {
        let ref = firebaseController.refuserTexts.child(userID)
        ref.observe(.value, with: { snapshot in
            if snapshot.childrenCount > 0 {
                var userTextList:[UserText] = []
                for text in snapshot.children.allObjects as! [DataSnapshot] {
                    let textObject = text.value as? [String:String]
                    if let textObj = textObject {
                        if let textID = textObj["userTextID"], let userEmail = textObj["userEmail"], let text = textObj["text"], let isQuote = textObj["isQuote"], let title = textObj["title"] {

                            let userText = UserText(userTextID: textID, userEmail: userEmail, title: title, text: text, isQoute: isQuote)
                            userTextList.append(userText)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(userTextList)
                }
            }
        })
    }

}
