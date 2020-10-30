//
//  ViewHelper.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 20/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class UIElementsHelper {
    // func copied from
    // https://gist.github.com/illescasDaniel/c1a97d0fae8e6cd1ff127bd399671ecd
    func alignTextVerticallyInContainer(textView:UITextView) {
        var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        textView.contentInset.top = topCorrect
    }
    
    
    func prepareImage(name:String) -> UIImage? {
        var image = UIImage(named: name)
        if let tintedImage = image {
            image = tintedImage.withTintColor (.systemOrange,renderingMode:.alwaysOriginal )
        }
        return image
    }
    
    func prepareImageWithTint(name:String, with tint:UIColor) -> UIImage? {
        var image = UIImage(named: name)
        if let tintedImage = image {
            image = tintedImage.withTintColor (tint, renderingMode:.alwaysOriginal )
        }
        return image
    }
    
}
