//
//  ViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 13/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//
import GoogleMobileAds
import UIKit
import Kingfisher
import ProgressHUD


class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var instagramShareButton: UIButton!
    @IBOutlet weak var facebookShareButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    let coreDataCtrl = CoreDataController.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .red
        ProgressHUD.animationType = .lineScaling
        ProgressHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
        Backgrounds().getBackgroundImage(imageView: backgroundImageView)
        Quotes().getQuote(quoteLabel: quoteLabel, authorLabel: authorNameLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func addToFavourites(_ sender: UIButton) {
        print("Adding to favourites > \(self.authorNameLabel)")
        let mainCtx = self.coreDataCtrl.mainCtx
        let favourite = Favourite(context: mainCtx)
        
        favourite.author = self.authorNameLabel.text
        favourite.quote = self.quoteLabel.text
        favourite.isFavourite = true
        
        if self.coreDataCtrl.save() {
            Toast().showToast(message: "SAVED 2 FAVOURITES", font: .systemFont(ofSize: 18.0), view: self.view)
        }
        
    }
    
    
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

