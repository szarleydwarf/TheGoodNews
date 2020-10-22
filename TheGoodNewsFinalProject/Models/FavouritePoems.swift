//
//  FavouritePoems.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 19/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData

class FavouritePoems {
    let coreDataController = CoreDataController.shared
    
    func fetchPoems(view: UIView, userEmail:String="Unknown@Unknown.org") -> [Poems] {
        var poems:[Poems] = []
        let ctx = coreDataController.mainCtx
        let request: NSFetchRequest<Poems> = Poems.fetchRequest()
        request.predicate = NSPredicate(format: "userEmail = %@", userEmail)
        do {
            poems = try ctx.fetch(request)
        } catch let err {
            Toast().showToast(message: "Error fetching poems \(err)", font: .systemFont(ofSize: 15), view:  view)
        }
        return poems
    }
    
    func savePoem(poetName:String = "UNKNOWN", poemTitle:String, poemText:String, userEmail:String="Unknown@Unknown.org") -> Bool {
        let ctx = self.coreDataController.mainCtx
        let poem = Poems(context: ctx)
        poem.author = poetName
        poem.title = poemTitle
        poem.poemText = poemText
        poem.isFavourite = true
        poem.userEmail = userEmail
        
        return self.coreDataController.save()
    }
    
    func deletePoem(poetName:String = "UNKNOWN", poemTitle:String, poemText:String, userEmail:String="Unknown@Unknown.org") -> Bool  {
        let ctx = self.coreDataController.mainCtx
        let request: NSFetchRequest<Poems> = Poems.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@ && title = %@ && poemText = %@ && userEmail = %@", poetName, poemTitle, poemText, userEmail)
        do {
            let result = try ctx.fetch(request)
            if result.count > 0 {
                ctx.delete(result[0])
            }
        } catch let err {
            print("deletion error in poems > \(err)")
        }
        
        return self.coreDataController.save()
    }
    
    func checkIfFavourite(poetName:String = "UNKNOWN", poemTitle:String, poemText:String, userEmail:String="Unknown@Unknown.org") -> Bool {
        let poems = self.fetchPoems(view: UIView())
        for favPoem in poems {
            if let email = favPoem.userEmail, email == userEmail{
                if poetName == favPoem.author{
                    if poemTitle == favPoem.title{
                        if poemText == favPoem.poemText {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
}