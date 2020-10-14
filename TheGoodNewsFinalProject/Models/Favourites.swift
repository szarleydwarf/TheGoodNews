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
    //    var fetchedFavourites:[Favourite]=[]
    let coreDataController = CoreDataController.shared
    
    func fetchFavourites(view:UIView) -> [Favourite] {
        var fetchedFavourites:[Favourite]=[]
        let ctx = coreDataController.mainCtx
        let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        do{
            fetchedFavourites = try ctx.fetch(fetchRequest)
        } catch let err {
            Toast().showToast(message: "Error fetching favourite quotes \(err)", font: .systemFont(ofSize: 20.0), view: view)
        }
        return fetchedFavourites
    }
    
    func saveFavourite(view:UIView, authorName:String, quote:String) {
        let mainCtx = self.coreDataController.mainCtx
        let favourite = Favourite(context: mainCtx)
        favourite.author = authorName
        favourite.quote = quote
        favourite.isFavourite = true
        
        if self.coreDataController.save() {
            Toast().showToast(message: "SAVED 2 FAVOURITES", font: .systemFont(ofSize: 18.0), view: view)
        }
    }
    
    func deleteFavourite(view:UIView ,author: String, quote: String) {
        let mainCtx = self.coreDataController.mainCtx
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@ && quote = %@", author, quote)

        do {
            let result = try mainCtx.fetch(request)
            if result.count > 0 {
                print("RESULT \(result)")
                mainCtx.delete(result[0])
            }
        } catch let err {
            print("fetch error \(err)")
        }
        
        
        if self.coreDataController.save() {
            Toast().showToast(message: "REMOVED FROM FAVOURITES", font: .systemFont(ofSize: 18.0), view: view)
        }
    }
    
    func checkIfFavourite(authorName:String, quote:String, favourites:[Favourite]) -> Bool{
        for favQuote in favourites {
            if let author = favQuote.author, let oneQoute = favQuote.quote {
                if author == authorName {
                    print("QUOTE > \(author) - \(authorName) -\n >\(oneQoute)< - >\(quote)<")
                    if oneQoute == quote {
                        print("QUOTE > >\(oneQoute)< - >\(quote)<")
                        
                        return true
                    }
                }
//                print("AUTHOR > \(favQuote.author) \(author)")
            }
        }
        return false
    }
}
