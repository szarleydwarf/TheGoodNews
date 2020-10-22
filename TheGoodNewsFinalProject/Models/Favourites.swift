//
//  Favourites.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 14/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData

class Favourites {
    let coreDataController = CoreDataController.shared
    // todo ad
    func fetchFavourites(view:UIView, userEmail:String="Unknown") -> [Favourite] {
        var fetchedFavourites:[Favourite]=[]
        let ctx = coreDataController.mainCtx
        let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userEmail = %@", userEmail)
        do{
            fetchedFavourites = try ctx.fetch(fetchRequest)
        } catch let err {
            Toast().showToast(message: "Error fetching favourite quotes \(err)", font: .systemFont(ofSize: 17.0), view: view)
        }
        return fetchedFavourites
    }
    
    func saveFavourite(authorName:String, quote:String, userEmail:String="Unknown") -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let favourite = Favourite(context: mainCtx)
        favourite.author = authorName
        favourite.quote = quote
        favourite.isFavourite = true
        favourite.userEmail = userEmail
        
        return self.coreDataController.save()
    }
    
    func deleteFavourite(author: String, quote: String, userEmail:String="Unknown") -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@ && quote = %@ && userEmail = %@", author, quote, userEmail)
        
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
    
    func checkIfFavourite(authorName:String, quote:String, userEmail:String="Unknown", favourites:[Favourite]) -> Bool{
        for favQuote in favourites {
            if let email = favQuote.userEmail, email == userEmail {
                if let author = favQuote.author, let oneQoute = favQuote.quote {
                    if author == authorName {
                        if oneQoute == quote {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func deleteAllCoreData(_ entityName:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try coreDataController.mainCtx.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                coreDataController.mainCtx.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entityName) error :", error)
        }
    }
}
