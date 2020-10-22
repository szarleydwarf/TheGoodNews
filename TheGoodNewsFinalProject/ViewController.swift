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
import Social


class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var fetchedFavourites:[Favourite]=[]
    var user:User = User()
    var email:String = ""
    let favImageStringTapped:String = "star_fav"
    let favImageString:String = "star"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .red
        ProgressHUD.animationType = .lineScaling
        ProgressHUD.show()
        
        self.email = user.email
        fetchedFavourites = Favourites().fetchFavourites(view: self.view, userEmail: email)
        
        //        Favourites().deleteAllCoreData("Favourite")
        //        Favourites().deleteAllCoreData("UserQuotePoems")
        
        Backgrounds().getBackgroundImage{ url in
            self.backgroundImageView.kf.setImage(with: url, placeholder: UIImage(imageLiteralResourceName:"landscape"))
            self.backgroundImageView.alpha = 0.3
        }
        
        Quotes().getQuote{ (author, quote) in
            self.quoteTextView.text = quote
            ViewHelper().alignTextVerticallyInContainer(textView: self.quoteTextView)
            self.authorNameLabel.text = author
            
            if let author = self.authorNameLabel.text, let quote = self.quoteTextView.text{
                let imageString = Favourites().checkIfFavourite(authorName: author, quote: quote, userEmail: self.email, favourites: self.fetchedFavourites) ? self.favImageStringTapped : self.favImageString
                self.favouriteButton.setImage(UIImage(named: imageString), for: .normal)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewHelper().alignTextVerticallyInContainer(textView: self.quoteTextView)
        ProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func addToFavourites(_ sender: UIButton) {
        if let author = self.authorNameLabel.text, let quote = self.quoteTextView.text {
            var message:String=""
            
            if Favourites().checkIfFavourite(authorName: author, quote: quote, userEmail: self.email , favourites: fetchedFavourites) {
                favouriteButton.setImage(UIImage(named: favImageString), for: .normal)
                if Favourites().deleteFavourite( author: author, quote: quote, userEmail: self.email ) {
                    message = "REMOVED FROM FAVOURITES"
                }
            } else {
                favouriteButton.setImage(UIImage(named: favImageStringTapped), for: .normal)
                if Favourites().saveFavourite(authorName: author, quote: quote, userEmail: self.email ) {
                    message = "SAVED TO FAVOURITES"
                }
            }
        
            Toast().showToast(message: message, font: .systemFont(ofSize: 22.0), view: self.view)
            self.fetchedFavourites = Favourites().fetchFavourites(view: self.view, userEmail: self.email )
        }
    }
    
    @IBAction func shareToSocialMedia(_ sender: UIButton) {
        if let quote = self.quoteTextView.text, let author = self.authorNameLabel.text {
            let objectToShare:[Any] = [quote, author]
            let activity = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            activity.popoverPresentationController?.sourceView = sender
            self.present(activity, animated: true, completion: nil)
        }
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    
}

