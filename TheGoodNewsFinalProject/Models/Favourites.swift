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
    var fetchedFavourites:[Favourite]=[]
    let coreDataController = CoreDataController.shared
    
    func fetchFavourites(view:UIView) {
         let ctx = coreDataController.mainCtx
         let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
         do{
             self.fetchedFavourites = try ctx.fetch(fetchRequest)
         } catch let err {
             Toast().showToast(message: "Error fetching favourite quotes \(err)", font: .systemFont(ofSize: 20.0), view: view)
         }
     }
     
     
     func checkIfFavourite() -> Bool{
         for quote in self.fetchedFavourites {
//             if quote.author == authorNameLabel.text {
//                 if quote.quote == quoteLabel.text {
//                     favouriteButton.backgroundColor = quote.isFavourite ? .red : .lightGray
//                     return true
//                 }
//             }
             print("QUOTE > \(quote.author)")
         }
         return false
     }
}
