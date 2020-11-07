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
    
    func fetchUserTexts (view: UIView, userEmail:String=Constants.stringValues.defaultUserEmail)->[UserQuotePoems] {
        var userText:[UserQuotePoems] = []
        let ctx = coreDataController.mainCtx
        let request: NSFetchRequest<UserQuotePoems> = UserQuotePoems.fetchRequest()
        request.predicate = NSPredicate(format: Constants.predicates.userEmail, userEmail)
        do{
            userText = try ctx.fetch(request)
        } catch let err {
            Toast().showToast(message: "\(Constants.error.fetchingText) \(err.localizedDescription)", font: .systemFont(ofSize: 15), view: view)
        }
        return userText
    }
    
    func saveUserQuoteOrPoem(title:String?, text:String, isQuote:Bool, userEmail:String=Constants.stringValues.defaultUserEmail) -> Bool {
        let context = self.coreDataController.mainCtx
        let userText = UserQuotePoems(context: context)
        
        userText.isQuote = isQuote
        userText.title = title
        userText.text = text
        userText.userEmail = userEmail
        
        return self.coreDataController.save()
    }
    
    func updateUserText(userEmail: String, title: String, text: String, isQoute: Bool, fireDataBaseID: String) -> Bool {
        let ctx = self.coreDataController.mainCtx
        let request:NSFetchRequest<UserQuotePoems> = UserQuotePoems.fetchRequest()
        request.predicate = NSPredicate(format: Constants.predicates.userEmailTitleText, userEmail, title, text)
        do {
            let result = try ctx.fetch(request)
            if result.count > 0 {
                result[0].fireDataBaseID = fireDataBaseID
            }
        } catch let err {
            print("\(Constants.error.userUpdate) \(err)")
        }
        return self.coreDataController.save()
    }
    
    func deleteUserText(title:String?, text:String, isQuote:Bool, userEmail:String=Constants.stringValues.defaultUserEmail) -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let request: NSFetchRequest<UserQuotePoems> = UserQuotePoems.fetchRequest()
        if let title = title {
            request.predicate = NSPredicate(format: Constants.predicates.textTitleIsQuoteUserEmail, text, title, NSNumber(booleanLiteral: isQuote), userEmail)
        } else {
            request.predicate = NSPredicate(format: Constants.predicates.textIsQuoteUserEmail, text, isQuote, userEmail)
        }
        
        do {
            let result = try mainCtx.fetch(request)
            if result.count > 0 {
                mainCtx.delete(result[0])
            }
        } catch let err {
            print("\(Constants.error.fetchingText) \(err)")
        }
        return self.coreDataController.save()
    }
    
    func getUserText(fireDataBaseObjec: UserText, userTextList: [UserQuotePoems]) -> UserQuotePoems? {
        if let userEmail = self.firebaseController.fAuth.currentUser?.email {
            return userTextList.first(where: {($0 == fireDataBaseObjec) && ($0.userEmail == userEmail)})
        }
        return nil
    }
    
    // Firebase Database func's
    let firebaseController = FireBaseController.shared
    
    struct UserText: Equatable {
        var userTextID:String
        var userEmail:String
        var title:String
        var text:String
        var isQoute:String
        
        var dictionary:[String:Any]{
            return [Constants.firebaseDictNames.textID:userTextID,
                    Constants.firebaseDictNames.userEmail:userEmail,
                    Constants.firebaseDictNames.title:title,
                    Constants.firebaseDictNames.text:text,
                    Constants.firebaseDictNames.isQuote:isQoute
            ]
        }
        
        static func == (lh: UserQuotePoems, rh: UserText) -> Bool{
            return lh.title == rh.title && lh.text == rh.text && lh.userEmail == rh.userEmail
        }
    }
    
    func boolToString(isQoute:Bool) -> String{
        if isQoute {
            return Constants.stringValues.yes
        }
        return Constants.stringValues.no
    }
    
    func stringToBool(isQoute:String) -> Bool {
        if isQoute == Constants.stringValues.yes {
            return true
        }
        return false
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
    
    func saveIntoFireDataBaseWithFireID(userID:String, fireID:String, userEmail:String, title:String, text:String, isQoute:Bool) -> Bool {
        let isQ = self.boolToString(isQoute: isQoute)
        let text = UserText(userTextID: fireID, userEmail: userEmail, title: title, text: text, isQoute: isQ)
        firebaseController.refuserTexts.child(userID).child(fireID).setValue(text.dictionary)
        return true
    }
    
    func saveTextWithFireDataBaseID(title:String, text:String, userEmail:String=Constants.stringValues.defaultUserEmail, fireDataBaseID: String, isQuote: Bool) -> Bool {
        let ctx = self.coreDataController.mainCtx
        let userText = UserQuotePoems(context: ctx)
        userText.title = title
        userText.text = text
        userText.userEmail = userEmail
        userText.isQuote = isQuote
        userText.fireDataBaseID = fireDataBaseID
        
        return self.coreDataController.save()
    }
    
    func fetchFromFireDataBase (userID:String, completion:@escaping(([UserText]))-> Void) {
        let ref = firebaseController.refuserTexts.child(userID)
        ref.observe(.value, with: { snapshot in
            var userTextList:[UserText] = []
            if snapshot.childrenCount > 0 {
                for text in snapshot.children.allObjects as! [DataSnapshot] {
                    let textObject = text.value as? [String:String]
                    if let textObj = textObject {
                        if let textID = textObj[Constants.firebaseDictNames.textID], let userEmail = textObj[Constants.firebaseDictNames.userEmail], let text = textObj[Constants.firebaseDictNames.text], let isQuote = textObj[Constants.firebaseDictNames.isQuote], let title = textObj[Constants.firebaseDictNames.title] {

                            let userText = UserText(userTextID: textID, userEmail: userEmail, title: title, text: text, isQoute: isQuote)
                            userTextList.append(userText)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completion(userTextList)
            }
        })
    }

}
