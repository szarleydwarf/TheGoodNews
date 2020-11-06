//
//  Favourites.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 14/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import FirebaseDatabase
/*
 Class to maintain CRUD actions in CoreData
 for user favourite qoutes
 **/
class Favourites {
    let coreDataController = CoreDataController.shared
    
    // CoreData func
    func fetchFavourites(view:UIView, userEmail:String=Constants.stringValues.defaultUserEmail) -> [Favourite] {
        var fetchedFavourites:[Favourite]=[]
        let ctx = coreDataController.mainCtx
        let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: Constants.predicates.userEmail, userEmail)
        do{
            fetchedFavourites = try ctx.fetch(fetchRequest)
        } catch let err {
            Toast().showToast(message: "Error fetching favourite quotes \(err)", font: .systemFont(ofSize: 17.0), view: view)
        }
        return fetchedFavourites
    }
    
    func saveFavourite(authorName:String, quote:String, userEmail:String=Constants.stringValues.defaultUserEmail) -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let favourite = Favourite(context: mainCtx)
        favourite.author = authorName
        favourite.quote = quote
        favourite.isFavourite = true
        favourite.userEmail = userEmail
        
        return self.coreDataController.save()
    }
    
    func saveFavouriteWithFireDataBaseID(authorName:String, quote:String, userEmail:String=Constants.stringValues.defaultUserEmail, fireDataBaseID: String) -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let favourite = Favourite(context: mainCtx)
        favourite.author = authorName
        favourite.quote = quote
        favourite.isFavourite = true
        favourite.userEmail = userEmail
        favourite.fireDataBaseID = fireDataBaseID
        
        return self.coreDataController.save()
    }
    
    func updateFavourite(authorName:String, quote:String, userEmail:String=Constants.stringValues.defaultUserEmail, fireDataBaseID: String) -> Bool {
        let ctx = self.coreDataController.mainCtx
        let request:NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.predicate = NSPredicate(format: Constants.predicates.authorQuoteUserEmail, authorName, quote, userEmail)
        do {
            let result = try ctx.fetch(request)
            if result.count > 0 {
                result[0].fireDataBaseID = fireDataBaseID
            }
        } catch let err {
            print("Update error \(err)")
        }
        return self.coreDataController.save()
    }
    
    func deleteFavourite(author: String, quote: String, userEmail:String=Constants.stringValues.defaultUserEmail) -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        request.predicate = NSPredicate(format: Constants.predicates.authorQuoteUserEmail, author, quote, userEmail)
        
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
    
    func checkIfFavourite(authorName:String, quote:String, userEmail:String=Constants.stringValues.defaultUserEmail, favourites:[Favourite]) -> Bool{
        return favourites.contains(where: {($0.userEmail == userEmail) && ($0.author == authorName) && ($0.quote == quote)})
    }
    
    func getFavouriteQoute(authorName:String, quote:String, userEmail:String=Constants.stringValues.defaultUserEmail, favourites:[Favourite]) -> Favourite? {
        return favourites.first(where: {($0.author == authorName) && ($0.quote == quote) && ($0.userEmail == userEmail)})
    }
    
    
    func getFavouriteQoute(fireDataBaseObject: FavQuote, favourites:[Favourite]) -> Favourite? {
        if let userEmail = firebaseController.fAuth.currentUser?.email {
            return favourites.first(where: {($0 == fireDataBaseObject) && ($0.userEmail == userEmail)})
        }
        return nil
    }
    
    // Firebase Database func's
    let firebaseController = FireBaseController.shared
    
    struct FavQuote : Equatable{
        var qid:String
        var author:String
        var quote:String
        
        
        var dictionary:[String:Any]{
            return ["qid":qid,
                    "author":author,
                    "quote":quote
            ]
        }
        
        static func == (lhFav:Favourite, rhFav:FavQuote) -> Bool{
            return lhFav.author == rhFav.author && lhFav.quote == rhFav.quote
        }
       
    }
    
    func saveIntoFireDatabaseReturnQouteID(userID:String, authorName:String, quoteText:String) -> String {
        if let quoteID = firebaseController.refFavQuotes.child(userID).childByAutoId().key{
            
            let quote = FavQuote(qid: quoteID, author: authorName, quote: quoteText)
            firebaseController.refFavQuotes.child(userID).child(quoteID)
                .setValue(quote.dictionary)
            return quoteID
        }
        return ""
    }
    
    func saveIntoFireDatabaseWithQouteID(userID:String, authorName:String, quoteText:String, fireDataBaseID: String) -> Bool {
        let quote = FavQuote(qid: fireDataBaseID, author: authorName, quote: quoteText)
        self.firebaseController.refFavQuotes.child(userID).child(fireDataBaseID).setValue(quote.dictionary)
        return true
    }

    func fetchFromFireDatabase(userID: String, completion:@escaping(([FavQuote])) -> Void) {
        let ref = firebaseController.refFavQuotes.child(userID)
        ref.observe(.value, with: { snapshot in
            var listOfQuotes:[FavQuote]=[]
            if snapshot.childrenCount > 0{
                for quote in snapshot.children.allObjects as! [DataSnapshot] {
                    let qouteObject = quote.value as? [String:String]
                    if let qObj = qouteObject {
                        if let quoteID = qObj["qid"], let qouteAuthor = qObj["author"], let quoteText = qObj["quote"] {
                            let favQuote = FavQuote(qid: quoteID, author: qouteAuthor, quote: quoteText)
                            listOfQuotes.append(favQuote)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                completion(listOfQuotes)
            }
        })
    }
    
    //to be removed before submission
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
