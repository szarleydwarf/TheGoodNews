//
//  Constants.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 30/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    //to be implemented later to hold all constant values
    struct sfNames {
        static let starInCircleFavourite = "star.circle"
        static let quote = "quote.bubble"
        static let poem = "heart.text.square"
    }
    
    struct numericValues {
        static let backgroundAlpha:CGFloat = 0.2
        static let toastFontSizeLarge:CGFloat = 22.0
        static let toastFontSizeNormal:CGFloat = 18.0
    }
    
    struct stringValues {
        static let defaultUserEmail = "Unknown@Unknown.org"
        static let defaultPoetName = "UNKNOWN"
        static let yes = "yes"
        static let no = "no"
        static let poem = "poem"
        static let quote = "quote"
        static let signOut = "Sign Out"
        static let signIn = "Sign In"
    }
    
    struct imageDefaultNames {
        static let backgroundPlaceholder = "landscape"
        static let profilePlaceholder = "profile"
    }
    
    struct urls {
        static let backgroundsAPI = "https://pixabay.com/api/?key=18691967-c6bbf9bfa8dba2ffd4c907bb5&q=beautiful+landscape&image_type=photo"
        static let quotesAPI = "https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en"
        static let poemsAPI = "https://www.poemist.com/api/v1/randompoems"
    }
    
    struct defaultMessages {
        static let quotesSaved = "QUOTES SAVED"
        static let savedToFavourites = "SAVED TO FAVOURITES"
        static let removedFromFavourites = "REMOVED FROM FAVOURITES"
        static let signingInRequiredToAddText = "You need to sign in to add your quote or poem"
        static let singningRequiredToUpdate = "You need to sign in to Sync your data"
        static let syncStarted = "Starting to syncing your favourites. Allow some time to finish"
        static let quotesSynced = "Qoutes sync completed"
        static let poemsSynced = "Poems sync completed"
        static let userTextSynced = "yuor texts sync completed"
        static let imageSaved = "Image Saved"
        static let emailAndPasswordRequired = "Enter email and password to sign in"
        static let thankYouForSigning = "Thank you for signing in. You will be redirected in 4s."
        static let savedWithFormat:NSString = "Your %@ was saved"
    }
    
    struct error {
        static let fetchingText = "Failed to fetch your texts >> "
        static let userUpdate = "User update error >> "
        static let fetchingQuotes = "Could not fetched favourite quotes >> "
        static let updateError = "Update error >> "
        static let deleting = "Could not delete, got error >> "
        static let fetchingPoems = "Could not fetched poems >> "
        static let signout = "Could not sign out >>"
        static let persistentContainer = "Unresolved lazy persistant container error >> "
        static let saving = "Could not save >> "
    }
    
    struct firebaseDictNames {
        static let quoteID = "qid"
        static let author = "author"
        static let quote = "quote"
        static let textID = "userTextID"
        static let userEmail = "userEmail"
        static let title = "title"
        static let text = "text"
        static let isQuote = "isQuote"
        static let poemID = "poemID"
        static let poemText = "poemText"
    }
    
    struct firebaseDataBaseRefNames {
        static let users = "users"
        static let quotes = "favQoutes"
        static let poems = "favPoems"
        static let userText = "userTexts"
        
    }
    
    struct predicates {
        static let userEmail = "userEmail = %@"
        static let authorQuoteUserEmail = "author = %@ && quote = %@ && userEmail = %@"
        static let userEmailTitleText = "userEmail = %@ && title = %@ && text = %@"
        static let textTitleIsQuoteUserEmail = "text = %@ && title = %@ && isQuote == %@ && userEmail = %@"
        static let textIsQuoteUserEmail = "text = %@ && isQuote && userEmail = %@"
        static let authorTitlePoemTextUserEmail = "author = %@ && title = %@ && poemText = %@ && userEmail = %@"
        
    }
    
    struct viewControllersNames {
        static let favouriteLists = "FavouritesListViewController"
        static let addUserText = "AddUserTextViewController"
        static let signIn = "SigningViewController"
        static let main = "ViewController"
        static let poems = "PoemsViewController"
    }
    
    struct iconColors {
        static let tappedTintColor:UIColor = .systemOrange
        static let defaultTintColor:UIColor = .systemGray
    }
    
    struct coredata {
        static let persistentContainarName = "TheGoodNewsFinalProject"
    }
}
