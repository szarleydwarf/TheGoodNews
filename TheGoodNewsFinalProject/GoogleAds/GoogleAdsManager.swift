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
    let banner:GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-1421069741839692/8814297048"
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
}
