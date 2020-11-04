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
            Favourites().fetchFromFireDatabase(userID: userID) { fireList in
                // check if core data list has uid
                var saved:Bool = false
                for favQuote in favouriteQuotesList {
                    //if not update id and update firedatabase
                    if favQuote.fireDataBaseID == nil {
                        if let author = favQuote.author,let quote = favQuote.quote, let email = favQuote.userEmail {
                            let quoteID = Favourites().saveIntoFireDatabaseReturnQouteID(userID: userID, authorName: author, quoteText: quote)
                            saved = Favourites().updateFavourite(authorName: author, quote: quote, userEmail: email, fireDataBaseID: quoteID)
                        }
                    } else {
                        if let author = favQuote.author,let quote = favQuote.quote, let fireDataBaseID = favQuote.fireDataBaseID {
                            saved = Favourites().saveIntoFireDatabaseWithQouteID(userID: userID, authorName: author, quoteText: quote, fireDataBaseID: fireDataBaseID)
                            
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
            FavouritePoems().fetchFromFireDatabase(userID: userID) { fireList in
                var saved:Bool = false
                for favPoem in favouritePoemsList {
                    if favPoem.fireDataBaseID == nil {
                        if let author = favPoem.author, let title = favPoem.title, let text = favPoem.poemText, let email = favPoem.userEmail {
                            let poemID = FavouritePoems().saveIntoFireDatabaseReturnPoemID(userID: userID, authorName: author, poemText: text, poemTitle: title)
                            saved = FavouritePoems().updatePoem(poetName: author, poemTitle: title, poemText: text, userEmail: email, fireDataBaseID: poemID)
                        }
                    } else {
                        if let author = favPoem.author, let title = favPoem.title, let text = favPoem.poemText, let fireBaseID = favPoem.fireDataBaseID {
                            saved = FavouritePoems().saveIntoFireDataBaseWithFireID(userID: userID, poetName: author, poemTitle: title, poemText: text, fireDataBaseID: fireBaseID)
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
            UserPoemsAndQutes().fetchFromFireDataBase(userID: userID) { fireList in
                var saved:Bool = false
                for userText in userTextList {
                    if userText.fireDataBaseID == nil || userText.fireDataBaseID == ""{
                        if let email = userText.userEmail, let text = userText.text, let title = userText.title {
                            let userTextID = UserPoemsAndQutes().saveIntoFireDataBaseReturnID(userID: userID, userEmail: email, title: title, text: text, isQoute: userText.isQuote)
                            saved = UserPoemsAndQutes().updateUserText( userEmail: email, title: title, text: text, isQoute: userText.isQuote, fireDataBaseID: userTextID)
                            print("SYNC USERTEXT >> \(saved) <<>> \(userTextID)")
                        }
                    } else {
                        if let email = userText.userEmail, let text = userText.text, let title = userText.title, let fireID = userText.fireDataBaseID {
                            saved = UserPoemsAndQutes().saveIntoFireDataBaseWithFireID(userID: userID, fireID: fireID, userEmail: email, title: title, text: text, isQoute: userText.isQuote)
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
    
    func syncPoemsIntoCoreData(favouritePoemsList:[Poems], completion:@escaping(Bool) -> Void) {
        if let userId = firebaseController.fAuth.currentUser?.uid {
            FavouritePoems().fetchFromFireDatabase(userID: userId) {
                fireBasePoemsList in
                if let userEmail = self.firebaseController.fAuth.currentUser?.email {
                    for firePoem in fireBasePoemsList{
                        if !FavouritePoems().checkIfFavourite(poetName: firePoem.author, poemTitle: firePoem.title, poemText: firePoem.poemText, userEmail: userEmail){
                            if FavouritePoems().savePoemWithFireDataBaseID(poetName: firePoem.author, poemTitle: firePoem.title, poemText: firePoem.poemText, userEmail: userEmail, fireDataBaseID: firePoem.poemID) {
                                  print("syncPoemsIntoCoreData Saved new poem")
                            }
                        } else {
                            guard let favPoem = FavouritePoems().getFavouritePoem(fireDataBaseObject:firePoem, favouriteList: favouritePoemsList) else {return}
                            if favPoem.fireDataBaseID == nil || favPoem.fireDataBaseID != firePoem.poemID {
                                if FavouritePoems().updatePoem(poetName: firePoem.author, poemTitle: firePoem.title, poemText: firePoem.poemText, userEmail: userEmail, fireDataBaseID: firePoem.poemID) {
                                     print("syncPoemsIntoCoreData sync id update")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func syncUserTextIntoCoreData(userTextList: [UserQuotePoems], completion:@escaping(Bool) -> Void) {
        if let userID = firebaseController.fAuth.currentUser?.uid {
            UserPoemsAndQutes().fetchFromFireDataBase(userID: userID) { fireBaseTexts in
                if let userEmail = self.firebaseController.fAuth.currentUser?.email {
                    for fireText in fireBaseTexts {
                        let userText = UserPoemsAndQutes().getUserText(fireDataBaseObjec: fireText, userTextList: userTextList)
                        let isQuote = UserPoemsAndQutes().stringToBool(isQoute: fireText.isQoute)
                        if userText == nil {
                            if UserPoemsAndQutes().saveTextWithFireDataBaseID(title: fireText.title, text: fireText.text,userEmail: userEmail, fireDataBaseID: fireText.userTextID, isQuote: isQuote){
                                print("syncUserTextIntoCoreData Saved new user text")
                            }
                        } else if userText?.fireDataBaseID == nil || userText?.fireDataBaseID != fireText.userTextID {
                            if UserPoemsAndQutes().updateUserText(userEmail: userEmail, title: fireText.title, text: fireText.text, isQoute: isQuote,  fireDataBaseID: fireText.userTextID) {
                                print("syncUserTextIntoCoreData update user text")
                            }
                        } else {

                        }
                    }
                }
            }
        }
    }
}
