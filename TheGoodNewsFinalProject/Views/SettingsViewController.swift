//
//  SettingsViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 15/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import GoogleMobileAds
import UIKit
import CoreData
import Kingfisher
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var user:User!
    var userName:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBanner()
        changeSignInButtonTitle()
        displayUserNameLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func showFavourites(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favouritesViewController = storyboard.instantiateViewController(identifier: "FavouritesListViewController") as! FavouritesListViewController
        self.navigationController?.pushViewController(favouritesViewController, animated: true)
    }
    
    @IBAction func signinOptions(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {

    }
    
   
    func changeSignInButtonTitle () {

    }
    
    func displayUserNameLabel() {
 
    }
    
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}
