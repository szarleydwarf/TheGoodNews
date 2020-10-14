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

        fetchFavourites()
        
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
        
        checkIfFavourite()
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
        if checkIfFavourite(){
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
    
    func fetchFavourites() {
        let ctx = self.coreDataCtrl.mainCtx
        let fetchRequest: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        do{
            self.fetchedFavourites = try ctx.fetch(fetchRequest)
        } catch let err {
            Toast().showToast(message: "Error fetching favourite quotes \(err)", font: .systemFont(ofSize: 20.0), view: self.view)
        }
    }
    
    
    func checkIfFavourite() -> Bool{
        for quote in self.fetchedFavourites {
            if quote.author == authorNameLabel.text {
                if quote.quote == quoteLabel.text {
                    favouriteButton.backgroundColor = quote.isFavourite ? .red : .lightGray
                    return true
                }
            }
            print("QUOTE > \(quote.author)")
        }
        return false
    }
    
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

