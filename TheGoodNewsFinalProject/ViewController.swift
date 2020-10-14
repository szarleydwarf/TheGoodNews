//
//  ViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 13/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//
import GoogleMobileAds
import UIKit
import CoreData
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
    var fetchedFavourites:[Favourite]=[]
    
    let coreDataCtrl = CoreDataController.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .red
        ProgressHUD.animationType = .lineScaling
        ProgressHUD.show()
        
        fetchedFavourites = Favourites().fetchFavourites(view: self.view)
        
        Backgrounds().getBackgroundImage(imageView: backgroundImageView)
        Quotes().getQuote{ (author, quote) in
            self.quoteLabel.text = quote
            self.authorNameLabel.text = author
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
        
//        Favourites().checkIfFavourite()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func addToFavourites(_ sender: UIButton) {
//        if yes remove in no add
        if let author = self.authorNameLabel.text, let quote = self.quoteLabel.text {
//        check if is not already in favourites
            if Favourites().checkIfFavourite(authorName: "Edwin Chapin", quote: "Every action of our lives touches on some chord that will vibrate in eternity", favourites: fetchedFavourites) {
                print("FOUND FAV")
                favouriteButton.backgroundColor = .red
            }
            
            
//            Favourites().save(view: self.view,authorName: author, quote: quote)
        }
    }
    
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

