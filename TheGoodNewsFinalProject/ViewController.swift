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
        
        Backgrounds().getBackgroundImage{ url in
            self.backgroundImageView.kf.setImage(with: url, placeholder: UIImage(imageLiteralResourceName:"landscape"))
            self.backgroundImageView.alpha = 0.4
        }
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
        if let author = self.authorNameLabel.text, let quote = self.quoteLabel.text {
            favouriteButton.backgroundColor = Favourites().checkIfFavourite(authorName: author, quote: quote, favourites: fetchedFavourites) ? .red : .lightGray
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func addToFavourites(_ sender: UIButton) {
        if let author = self.authorNameLabel.text, let quote = self.quoteLabel.text {
            var message:String=""
            if Favourites().checkIfFavourite(authorName: author, quote: quote, favourites: fetchedFavourites) {
                favouriteButton.backgroundColor = .lightGray
                if Favourites().deleteFavourite( author: author, quote: quote) {
                    message = "REMOVED FROM FAVOURITES"
                }
            } else {
                favouriteButton.backgroundColor = .red
                if Favourites().saveFavourite(authorName: author, quote: quote) {
                    message = "SAVED 2 FAVOURITES"
                }
            }
            Toast().showToast(message: message, font: .systemFont(ofSize: 22.0), view: self.view)
            self.fetchedFavourites = Favourites().fetchFavourites(view: self.view)
        }
    }
    
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

