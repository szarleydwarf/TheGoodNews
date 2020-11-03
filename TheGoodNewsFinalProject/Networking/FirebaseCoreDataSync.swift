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
    
    func syncQuotesToFireDataBase(favouriteQuotesList:[Favourite], completion:@escaping(Bool) -> Void) {
        // get firebase qoute list
        if let userID = firebaseController.fAuth.currentUser?.uid {
            Favourites().fetchFromFireDatabase(userID: userID) { firebaseQouteList in
                // check if core data list has uid
                var saved:Bool = false
                for favQuote in favouriteQuotesList {
                    //if not update id and update firedatabase
                    if favQuote.fireDataBaseID == nil {
                        if let author = favQuote.author,let quote = favQuote.quote, let email = favQuote.userEmail {
                            let quoteID = Favourites().saveIntoFireDatabaseReturnQouteID(userID: userID, authorName: author, quoteText: quote)
                            saved = Favourites().updateFavourite(authorName: author, quote: quote, userEmail: email, fireDataBaseID: quoteID)
                        }
                    }
                }
                DispatchQueue.main.async {
                    print("2. SYNC >> \(saved)<< >>")
                    completion(saved)
                }
            }
        }
    }
    
    func syncPoemsToFireDataBase(favouritePoemsList:[Poems], completion:@escaping(Bool) -> Void) {
        if let userID = firebaseController.fAuth.currentUser?.uid {
            FavouritePoems().fetchFromFireDatabase(userID: userID) { firebaseList in
                var saved:Bool = false
                for favPoem in favouritePoemsList {
                    if favPoem.fireDataBaseID == nil {
                        if let author = favPoem.author, let title = favPoem.title, let text = favPoem.poemText, let email = favPoem.userEmail {
                            let poemID = FavouritePoems().saveIntoFireDatabaseReturnQouteID(userID: userID, authorName: author, poemText: text, poemTitle: title)
                            saved = FavouritePoems().updatePoem(poetName: author, poemTitle: title, poemText: text, userEmail: email, fireDataBaseID: poemID)
                        }
                    }
                }
                DispatchQueue.main.async {
                    print("SYNC POEMS >> \(saved) <<>> ")
                    completion(saved)
                }
            }
        }
    }
    
    func syncUserTextToFireDataBase(userTextList:[UserQuotePoems], completion:@escaping(Bool) -> Void) {
        if let userID = firebaseController.fAuth.currentUser?.uid {
            UserPoemsAndQutes().fetchFromFireDataBase(userID: userID) { firebaseList in
                var saved:Bool = false
                for userText in userTextList {
                    if userText.fireDataBaseID == nil {
                        if let email = userText.userEmail, let text = userText.text, let title = userText.title {
                            let userTextID = UserPoemsAndQutes().saveIntoFireDataBaseReturnID(userID: userID, userEmail: email, title: title, text: text, isQoute: userText.isQuote)
                            saved = UserPoemsAndQutes().updateUserText( userEmail: email, title: title, text: text, isQoute: userText.isQuote, fireDataBaseID: userTextID)
                            print("SYNC USERTEXT >> \(saved) <<>> \(userTextID)")
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(saved)
                }
            }
        }
    }
    
    func syncQuotesIntoCoreData (favouriteQuotesList:[Favourite], completion:@escaping(Bool) -> Void) {
        if let userID = firebaseController.fAuth.currentUser?.uid {
            Favourites().fetchFromFireDatabase(userID: userID) { firebaseQouteList in
                // itereate over lists to check if they containe the same quotes&authors
                // Skip checking ids as those my be different, compare by other elements
                // assumption that both list contain one copy of a qoute&author combination per user
                if let userEmail = self.firebaseController.fAuth.currentUser?.email{
                    for fireQuote in firebaseQouteList {
                        if !Favourites().checkIfFavourite(authorName: fireQuote.author, quote: fireQuote.quote, userEmail: userEmail, favourites: favouriteQuotesList) {
                            if Favourites().saveFavouriteWithFireDataBaseID(authorName: fireQuote.author, quote: fireQuote.quote, userEmail: userEmail, fireDataBaseID: fireQuote.qid) {
                                print("syncQuotesIntoCoreData Saved new quote")
                            }
                        } else {
                            guard let favQuote = Favourites().getFavouriteQoute(fireDataBaseObject: fireQuote, favourites: favouriteQuotesList) else {return}
                            if favQuote.fireDataBaseID == nil || fireQuote.qid != favQuote.fireDataBaseID {
                                if Favourites().updateFavourite(authorName: fireQuote.author, quote: fireQuote.quote, userEmail: userEmail, fireDataBaseID: fireQuote.qid) {
                                    print("syncQuotesIntoCoreData sync id update")
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
}
