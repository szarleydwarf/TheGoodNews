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
    
    @IBOutlet weak var favouriteButton: UIButton!
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var handle:AuthStateDidChangeListenerHandle?
    var fetchedFavourites:[Favourite]=[]
    var email:String = ""
    var quoteFromFavouriteTabel:Bool = false
    var favouriteQouteFromTable:Favourite?
    
    let fbAuth = FireBaseController.shared
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorAnimation = .red
        ProgressHUD.animationType = .lineScaling
        ProgressHUD.show()
        
        self.setDelegates()
        
        handle = fbAuth.fAuth.addStateDidChangeListener { (auth, user) in
            if self.email.isEmpty, let email = user?.email {
                self.email = email
            } else if user == nil {
                self.email = ""
            }
            self.fetchedFavourites = Favourites().fetchFavourites(view: self.view, userEmail: self.email)
        }

        setBackground()
        if !quoteFromFavouriteTabel {
            setQuote()
        } else {
            guard let favQoute = self.favouriteQouteFromTable else {return}
            self.updateQouteView(with: favQoute)
        }
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
                tintColor = Constants.iconColors.defaultTintColor
                if Favourites().deleteFavourite( author: author, quote: quote, userEmail: self.email) {
                    message = Constants.defaultMessages.removedFromFavourites
                }
            } else {
                tintColor = Constants.iconColors.tappedTintColor
                if Favourites().saveFavourite(authorName: author, quote: quote, userEmail: self.email ) {
                    message = Constants.defaultMessages.savedToFavourites
                }
            }
            favouriteButton.tintColor = tintColor
            
            Toast().showToast(message: message, font: .systemFont(ofSize: Constants.numericValues.toastFontSizeNormal), view: self.view)
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
    
    func setDelegates() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllersNames.favouriteLists) as! FavouritesListViewController
        favListViewController.delegateQuotes = self
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    func setBackground() {
        Backgrounds().getBackgroundImage{ url in
            self.backgroundImageView.kf.setImage(with: url, placeholder: UIImage(imageLiteralResourceName: Constants.imageDefaultNames.backgroundPlaceholder))
            self.backgroundImageView.alpha = Constants.numericValues.backgroundAlpha
        }
    }
    
    func setQuote() {
        Quotes().getQuote{ (author, quote) in
            self.quoteTextView.text = quote
            UIElementsHelper().alignTextVerticallyInContainer(textView: self.quoteTextView)
            self.authorNameLabel.text = author
            if let author = self.authorNameLabel.text, let quote = self.quoteTextView.text{
                let tintColor = Favourites().checkIfFavourite(authorName: author, quote: quote, userEmail: self.email, favourites: self.fetchedFavourites) ? Constants.iconColors.tappedTintColor : Constants.iconColors.defaultTintColor
                
                self.favouriteButton.tintColor = tintColor
            }
        }
    }
}

extension ViewController: FavouritesListViewControllerQuotesDelegate {
    func updateQouteView(with quote: Favourite) {
        self.quoteTextView.text = quote.quote
        self.authorNameLabel.text = quote.author
        self.favouriteButton.tintColor = Constants.iconColors.tappedTintColor
    }
}
