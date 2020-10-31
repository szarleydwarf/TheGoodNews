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
    func fetchFavourites(view:UIView, userEmail:String="Unknown@Unknown.org") -> [Favourite] {
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
    
    func saveFavourite(authorName:String, quote:String, userEmail:String="Unknown@Unknown.org") -> Bool {
        let mainCtx = self.coreDataController.mainCtx
        let favourite = Favourite(context: mainCtx)
        favourite.author = authorName
        favourite.quote = quote
        favourite.isFavourite = true
        favourite.userEmail = userEmail
        
        return self.coreDataController.save()
    }
    
    func deleteFavourite(author: String, quote: String, userEmail:String="Unknown@Unknown.org") -> Bool {
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
    
    func checkIfFavourite(authorName:String, quote:String, userEmail:String="Unknown@Unknown.org", favourites:[Favourite]) -> Bool{
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
    
    // Firebase Database func
    let firebaseController = FireBaseController.shared
    
    struct FavQuote {
        var qid:String
        var author:String
        var quote:String
        
        
        var dictionary:[String:Any]{
            return ["qid":qid,
                    "author":author,
                    "quote":quote
            ]
        }
    }
    
    func saveIntoFireDatabase(userID:String, authorName:String, quoteText:String) {
        if let quoteID = firebaseController.refFavQuotes.child(userID).childByAutoId().key{
            
            let quote = FavQuote(qid: quoteID, author: authorName, quote: quoteText)
            firebaseController.refFavQuotes.child(userID).child(quoteID)
                .setValue(quote.dictionary)
        }
    }
    
    func fetchFromFireDatabase(userID: String, completion:@escaping(([FavQuote])) -> Void) {
        var listOfQuotes:[FavQuote]=[]

        let ref = firebaseController.refFavQuotes.child(userID)
        ref.observe(.value, with: { snapshot in
            if snapshot.childrenCount > 0{
                for quote in snapshot.children.allObjects as! [DataSnapshot] {
                    print("3. FIREBASE \(quote)")
                    let qouteObject = quote.value as? [String:String]
                    if let qObj = qouteObject {
                        if let quoteID = qObj["qid"], let qouteAuthor = qObj["author"], let quoteText = qObj["quote"] {
                            
                            let favQuote = FavQuote(qid: quoteID, author: qouteAuthor, quote: quoteText)
                            print("4. Fetching data fro FIREBASE \(favQuote)")
                            listOfQuotes.append(favQuote)
                            
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(listOfQuotes)
                }
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
