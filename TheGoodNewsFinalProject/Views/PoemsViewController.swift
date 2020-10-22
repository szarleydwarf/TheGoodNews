//
//  PoemsViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 15/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import GoogleMobileAds
import UIKit
import Kingfisher
import ProgressHUD
import Social

class PoemsViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var poemTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var poemTextView: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var fetchedPoems:[Poems] = []
    var user:User = User()
    var email:String = ""
    let favImageStringTapped:String = "star_fav"
    let favImageString:String = "star"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.colorHUD = .red
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.show()
        
        self.email = user.email
        fetchedPoems = FavouritePoems().fetchPoems(view: self.view, userEmail: self.email)
        
        Backgrounds().getBackgroundImage{ url in
            self.backgroundImageView.kf.setImage(with: url, placeholder: UIImage(imageLiteralResourceName:"landscape"))
            self.backgroundImageView.alpha = 0.3
        }
        
        PoemModel().getPoem{author, title, poem in
            self.authorLabel.text = author
            self.poemTitleLabel.text = title
            self.poemTextView.text = poem
            
            var imageName = FavouritePoems().checkIfFavourite(poetName: author, poemTitle: title, poemText: poem, userEmail: self.email) ? self.favImageStringTapped : self.favImageString
            self.favouriteButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouriteButton.layer.cornerRadius = 15
        setBanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func saveFavourite(_ sender: UIButton) {
        if let author = self.authorLabel.text, let title = self.poemTitleLabel.text, let poemText = self.poemTextView.text {
            var message:String = ""
            if FavouritePoems().checkIfFavourite(poetName: author, poemTitle: title, poemText: poemText, userEmail: self.email) {
                favouriteButton.setImage(UIImage(named: favImageString), for: .normal)
                if FavouritePoems().deletePoem(poetName: author, poemTitle: title, poemText: poemText, userEmail: self.email) {
                    message = "REMOVED FROM FAVOURITES"
                }
            } else {
                favouriteButton.setImage(UIImage(named: favImageStringTapped), for: .normal)
                if FavouritePoems().savePoem(poetName: author, poemTitle: title, poemText: poemText, userEmail: self.email){
                    message = "SAVED TO FAVOURITES"
                }
            }
            Toast().showToast(message: message, font: .systemFont(ofSize: 22.0), view: self.view)
            self.fetchedPoems = FavouritePoems().fetchPoems(view: self.view)
        }
    }
    
    @IBAction func sharePoem(_ sender: UIButton) {
        if let author = self.authorLabel.text, let title = self.poemTitleLabel.text, let poemText = self.poemTextView.text {
            let objectToShare:[Any] = [author, title, poemText]
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
