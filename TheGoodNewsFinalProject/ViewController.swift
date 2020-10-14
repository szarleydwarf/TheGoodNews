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
        
        Favourites().fetchFavourites(view: self.view)
        
        Backgrounds().getBackgroundImage(imageView: backgroundImageView)
        Quotes().getQuote(quoteLabel: quoteLabel, authorLabel: authorNameLabel)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
        
        Favourites().checkIfFavourite()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func addToFavourites(_ sender: UIButton) {
        print("Adding to favourites > \(self.authorNameLabel)")
        let mainCtx = self.coreDataCtrl.mainCtx
        let favourite = Favourite(context: mainCtx)
        var message:String = ""
        if Favourites().checkIfFavourite(){
            message = "REMOVING FROM FAVOURITES"
            self.favouriteButton.backgroundColor = .lightGray
            self.coreDataCtrl.mainCtx.delete(favourite)
        } else {
            favourite.author = self.authorNameLabel.text
            favourite.quote = self.quoteLabel.text
            favourite.isFavourite = true
            message = "SAVED 2 FAVOURITES"
            self.favouriteButton.backgroundColor = .red
        }
        if self.coreDataCtrl.save() {
            Toast().showToast(message: message, font: .systemFont(ofSize: 18.0), view: self.view)
        }
    }
    
 
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

