//
//  GoogleAdsManager.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 13/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//
import GoogleMobileAds
import Foundation

class GoogleAdsManager {
    func getBannerSize(size:CGSize) -> CGRect {
        let rect = CGRect(x: 0, y: size.height-70, width: size.width, height: 50)
        return rect
        
    }
    
    func getBanner() -> GADBannerView {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-1421069741839692/8814297048"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
        
    }
    
}
