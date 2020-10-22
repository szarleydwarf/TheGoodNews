//
//  UserPoemsAndQutes.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 18/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData

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
}
