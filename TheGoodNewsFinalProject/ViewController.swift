//
//  ViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 13/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//
import GoogleMobileAds
import Firebase
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
    var handle:AuthStateDidChangeListenerHandle?
    var fetchedFavourites:[Favourite]=[]
    var email:String = ""
    let fbAuth = FireBaseController.shared
    let tappedTintColor:UIColor = .systemOrange
    let defaultTintColor:UIColor = .systemGray
    let favouriteImageName:String = "star.circle"

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .red
        ProgressHUD.animationType = .lineScaling
        ProgressHUD.show()
        print("viewWillAppear > \(self.email) <> \(fbAuth.fAuth.currentUser)<")
        handle = fbAuth.fAuth.addStateDidChangeListener { (auth, user) in
            if self.email.isEmpty, let email = user?.email {
                self.email = email
            } else if user == nil {
                self.email = ""
            }
            self.fetchedFavourites = Favourites().fetchFavourites(view: self.view, userEmail: self.email)
        }
        
//Favourites().deleteAllCoreData("Favourite")
//Favourites().deleteAllCoreData("Poems")
//Favourites().deleteAllCoreData("UserQuotePoems")
        
        setBackground()
        setQuote()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fbAuth.fAuth.removeStateDidChangeListener(handle!)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIElementsHelper().alignTextVerticallyInContainer(textView: self.quoteTextView)
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
            var tintColor:UIColor?
            
            if Favourites().checkIfFavourite(authorName: author, quote: quote, userEmail: self.email, favourites: fetchedFavourites) {
                tintColor = self.defaultTintColor
                if Favourites().deleteFavourite( author: author, quote: quote, userEmail: self.email) {
                    message = "REMOVED FROM FAVOURITES"
                }
            } else {
                tintColor = self.tappedTintColor
                if Favourites().saveFavourite(authorName: author, quote: quote, userEmail: self.email ) {
                    message = "SAVED TO FAVOURITES"
                }
            }
            favouriteButton.tintColor = tintColor
                    
            Toast().showToast(message: message, font: .systemFont(ofSize: 22.0), view: self.view)
            self.fetchedFavourites = Favourites().fetchFavourites(view: self.view, userEmail: self.email )
        }
    }
    
    @IBAction func shareToSocialMedia(_ sender: UIButton) {
        if let quote = self.quoteTextView.text, let author = self.authorNameLabel.text {
            let objectToSave:String = "\"\(quote)\"\n\nBy \(author)"
            let objectToShare:[Any] = [objectToSave]
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
    
    func setBackground() {
        Backgrounds().getBackgroundImage{ url in
            self.backgroundImageView.kf.setImage(with: url, placeholder: UIImage(imageLiteralResourceName:"landscape"))
            self.backgroundImageView.alpha = 0.3
        }
    }
    
    func setQuote() {
        Quotes().getQuote{ (author, quote) in
            self.quoteTextView.text = quote
            UIElementsHelper().alignTextVerticallyInContainer(textView: self.quoteTextView)
            self.authorNameLabel.text = author
            if let author = self.authorNameLabel.text, let quote = self.quoteTextView.text{
                let tintColor = Favourites().checkIfFavourite(authorName: author, quote: quote, userEmail: self.email, favourites: self.fetchedFavourites) ? self.tappedTintColor : self.defaultTintColor

                self.favouriteButton.tintColor = tintColor
            }
        }
    }
}

