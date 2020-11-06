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
    }
    
    struct numericValues {
        static let backgroundAlpha:CGFloat = 0.2
        static let toastFontSizeLarge:CGFloat = 22.0
        static let toastFontSizeNormal:CGFloat = 18.0
    }
    
    struct stringValues {
        static let defaultUserEmail = "Unknown@Unknown.org"
    }
    
    struct imageDefaultNames {
        static let backgroundPlaceholder = "landscape"
    }
    
    struct urls {
        static let backgroundsAPI = "https://pixabay.com/api/?key=18691967-c6bbf9bfa8dba2ffd4c907bb5&q=beautiful+landscape&image_type=photo"
        static let quotesAPI = "https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en"
    }
    
    struct defaultMessages {
        static let quotesSaved = "QUOTES SAVED"
        static let savedToFavourites = "SAVED TO FAVOURITES"
        static let removedFromFavourites = "REMOVED FROM FAVOURITES"
    }
    
    struct predicates {
        static let userEmail = "userEmail = %@"
        static let authorQuoteUserEmail = "author = %@ && quote = %@ && userEmail = %@"
    }
    
    struct viewControllersNames {
        static let favouriteLists = "FavouritesListViewController"
    }
    
    struct iconColors {
        static let tappedTintColor:UIColor = .systemOrange
        static let defaultTintColor:UIColor = .systemGray
    }
}
