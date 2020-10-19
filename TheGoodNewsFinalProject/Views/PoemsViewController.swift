//
//  PoemsViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 15/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import GoogleMobileAds
import UIKit
import CoreData
import Kingfisher
import ProgressHUD
import Social

class PoemsViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var poemTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var poemLabel: UILabel!
    @IBOutlet weak var poemsScrollView: UIScrollView!
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func saveFavourite(_ sender: UIButton) {
    }
    
    @IBAction func sharePoem(_ sender: Any) {
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}
