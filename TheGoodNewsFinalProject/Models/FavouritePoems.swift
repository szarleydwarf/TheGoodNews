//
//  FavouritePoems.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 19/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

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
    
    func savePoemWithFireDataBaseID(poetName:String = "UNKNOWN", poemTitle:String, poemText:String, userEmail:String="Unknown@Unknown.org", fireDataBaseID:String) -> Bool {
        let ctx = self.coreDataController.mainCtx
        let poem = Poems(context: ctx)
        poem.author = poetName
        poem.title = poemTitle
        poem.poemText = poemText
        poem.isFavourite = true
        poem.userEmail = userEmail
        poem.fireDataBaseID = fireDataBaseID
        
        return self.coreDataController.save()
    }
    
    func updatePoem(poetName:String = "UNKNOWN", poemTitle:String, poemText:String, userEmail:String="Unknown@Unknown.org", fireDataBaseID: String) -> Bool{
        let ctx = self.coreDataController.mainCtx
        let request:NSFetchRequest<Poems> = Poems.fetchRequest()
        request.predicate = NSPredicate(format: "author = %@ && title = %@ && poemText = %@ && userEmail = %@", poetName, poemTitle, poemText, userEmail)
        do {
            let result = try ctx.fetch(request)
            if result.count > 0{
                result[0].fireDataBaseID = fireDataBaseID
            }
        } catch let err {
            print("Poem update error >> \(err.localizedDescription)")
        }
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
        let poems = self.fetchPoems(view: UIView(), userEmail: userEmail)
        return poems.contains(where: {($0.userEmail == userEmail) && ($0.author == poetName) && ($0.title == poemTitle) && $0.poemText == poemText})
    }
    
    func getFavouritePoem(fireDataBaseObject:FavPoem, favouriteList: [Poems]) -> Poems? {
        if let userEmail = firebaseController.fAuth.currentUser?.email {
            return favouriteList.first(where: {($0 == fireDataBaseObject) && ($0.userEmail == userEmail)})
        }
        return nil
    }
  
    // Firebase Database func's
    let firebaseController = FireBaseController.shared

    struct FavPoem: Equatable {
        var poemID:String
        var author:String
        var title:String
        var poemText:String
        
        var favoritePoem:[String:String] {
            return ["poemID": poemID,
                    "author": author,
                    "title": title,
                    "poemText":poemText
            ]
        }
        
        static func == (lh:Poems, rh: FavPoem) -> Bool{
            return lh.author == rh.author && lh.title == rh.title && lh.poemText == rh.poemText
        }
    }
    
    func saveIntoFireDatabaseReturnPoemID(userID:String, authorName:String, poemText:String, poemTitle:String) -> String {
         if let poemID = firebaseController.refFavPoems.child(userID).childByAutoId().key{
             
             let poem = FavPoem(poemID: poemID, author: authorName, title: poemTitle, poemText: poemText)
             firebaseController.refFavPoems.child(userID).child(poemID)
                 .setValue(poem.favoritePoem)
             return poemID
         }
         return ""
     }
    
    func saveIntoFireDataBaseWithFireID(userID: String, poetName: String, poemTitle: String, poemText: String, fireDataBaseID: String) -> Bool {
        let poem = FavPoem(poemID: fireDataBaseID, author: poetName, title: poemTitle, poemText: poemText)
        firebaseController.refFavPoems.child(userID).child(fireDataBaseID)
            .setValue(poem.favoritePoem)
        
        return true
    }

     func fetchFromFireDatabase(userID: String, completion:@escaping(([FavPoem])) -> Void) {
         let ref = firebaseController.refFavPoems.child(userID)
         ref.observe(.value, with: { snapshot in
             var listOfPoems:[FavPoem]=[]
             if snapshot.childrenCount > 0{
                 for poem in snapshot.children.allObjects as! [DataSnapshot] {
                     let poemObject = poem.value as? [String:String]
                     if let pObj = poemObject {
                         if let poemID = pObj["poemID"], let poemAuthor = pObj["author"], let poemText = pObj["poemText"], let poemTitle = pObj["title"] {
                             let favPoem = FavPoem(poemID: poemID, author: poemAuthor, title: poemTitle, poemText: poemText)
                             listOfPoems.append(favPoem)
                         }
                     }
                 }
             }
             DispatchQueue.main.async {
                 completion(listOfPoems)
             }
         })
     }

}
