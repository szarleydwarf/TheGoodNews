//
//  FirebaseCoreDataSync.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 31/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation

class FirebaseCoreDataSync {
    let firebaseController = FireBaseController.shared
    
    func syncQuotesToFireDataBase(favouriteQuotesList:[Favourite]) -> Bool {
        // get firebase qoute list
        var saved:Bool = false
        if let userID = firebaseController.fAuth.currentUser?.uid {
            Favourites().fetchFromFireDatabase(userID: userID) { firebaseQouteList in
                // check if core data list has uid
                for favQuote in favouriteQuotesList {
                    //if not update id and update firedatabase
                    if favQuote.fireDataBaseID == nil {
                        if let author = favQuote.author,let quote = favQuote.quote, let email = favQuote.userEmail {
                            let quoteID = Favourites().saveIntoFireDatabaseReturnQouteID(userID: userID, authorName: author, quoteText: quote)
                            saved = Favourites().updateFavourite(authorName: author, quote: quote, userEmail: email, fireDataBaseID: quoteID)
                            print("2. SYNC >> \(saved)<< \(quoteID)>>")
                        }
                    }
                }
            }
        }
        return saved
    }
    
    func syncPoemsToFireDataBase(favouritePoemsList:[Poems]) -> Bool {
        var saved:Bool = false
        if let userID = firebaseController.fAuth.currentUser?.uid {
            FavouritePoems().fetchFromFireDatabase(userID: userID) { firebaseList in
                for favPoem in favouritePoemsList {
                    if favPoem.fireDataBaseID == nil {
                        if let author = favPoem.author, let title = favPoem.title, let text = favPoem.poemText, let email = favPoem.userEmail {
                            let poemID = FavouritePoems().saveIntoFireDatabaseReturnQouteID(userID: userID, authorName: author, poemText: text, poemTitle: title)
                            saved = FavouritePoems().updatePoem(poetName: author, poemTitle: title, poemText: text, userEmail: email, fireDataBaseID: poemID)
                            print("SYNC POEMS >> \(saved) <<>> \(poemID)")
                        }
                    }
                }
            }
        }
        return saved
    }
}
