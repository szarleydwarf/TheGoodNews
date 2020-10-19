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
    
    func fetchUserTexts (view: UIView)->[UserQuotePoems] {
        var userText:[UserQuotePoems] = []
        let ctx = coreDataController.mainCtx
        let request: NSFetchRequest<UserQuotePoems> = UserQuotePoems.fetchRequest()
        do{
            userText = try ctx.fetch(request)
        } catch let err {
            Toast().showToast(message: "Failed to fetch your texts \(err.localizedDescription)", font: .systemFont(ofSize: 15), view: view)
        }
        return userText
    }
    
    func saveUserQuoteOrPoem(title:String?, text:String, isQuote:Bool) -> Bool {
        let context = self.coreDataController.mainCtx
        let userText = UserQuotePoems(context: context)
        
        userText.isQuote = isQuote
        userText.title = title
        userText.text = text
        
        return self.coreDataController.save()
    }
    
    func deleteUserText(title:String?, text:String, isQuote:Bool) -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        if let title = title {
            request.predicate = NSPredicate(format: "text = %@ && title = %@ && isQuote", text, title, isQuote)
        } else {
            request.predicate = NSPredicate(format: "text = %@ && isQuote", text, isQuote)
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
