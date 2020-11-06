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
    
    struct imageDefaultNames {
        static let backgroundPlaceholder = "landscape"
    }
    
    struct defaultMessages {
        static let quotesSaved = "QUOTES SAVED"
        static let savedToFavourites = "SAVED TO FAVOURITES"
        static let removedFromFavourites = "REMOVED FROM FAVOURITES"
    }
    
    struct viewControllersNames {
        static let favouriteLists = "FavouritesListViewController"
    }
    
    struct iconColors {
        static let tappedTintColor:UIColor = .systemOrange
        static let defaultTintColor:UIColor = .systemGray
    }
}
