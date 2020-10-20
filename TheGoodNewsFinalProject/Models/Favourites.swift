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
    
    func fetchFavourites(view:UIView) -> [Favourite] {
        var fetchedFavourites:[Favourite]=[]
        let ctx = coreDataController.mainCtx
        let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        do{
            fetchedFavourites = try ctx.fetch(fetchRequest)
        } catch let err {
            Toast().showToast(message: "Error fetching favourite quotes \(err)", font: .systemFont(ofSize: 17.0), view: view)
        }
        return fetchedFavourites
    }
    
    func saveFavourite(authorName:String, quote:String) -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let favourite = Favourite(context: mainCtx)
        favourite.author = authorName
        favourite.quote = quote
        favourite.isFavourite = true
        
        return self.coreDataController.save()
    }
    
    func deleteFavourite(author: String, quote: String) -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@ && quote = %@", author, quote)
        
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
    
    func checkIfFavourite(authorName:String, quote:String, favourites:[Favourite]) -> Bool{
        for favQuote in favourites {
            if let author = favQuote.author, let oneQoute = favQuote.quote {
                if author == authorName {
                    if oneQoute == quote {
                        return true
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
