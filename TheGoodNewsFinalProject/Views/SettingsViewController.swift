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
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var user:User!
    var userName:String = ""
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        user = User()
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
        //change sign in to sign off
        if user == nil || !user.isSigned {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            do {
                try Auth.auth().signOut()
                user.isSigned = false
                changeSignInButtonTitle()
                displayUserNameLabel()
            } catch let err{
                Toast().showToast(message: "could not sign out \(err)", font: .systemFont(ofSize: 16), view: self.view)
            }
        }
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        if user != nil && user.isSigned {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addTextViewController = storyboard.instantiateViewController(identifier: "AddUserTextViewController") as! AddUserTextViewController
            self.navigationController?.pushViewController(addTextViewController, animated: true)
        } else {
            Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
        }
    }
    
   
    func changeSignInButtonTitle () {
        var title = "Sign In"
        if user != nil {
            title =  user.isSigned ? "Sign Out" : "Sign In"
        }
        self.signInButton.setTitle(title, for: .normal)
    }
    
    func displayUserNameLabel() {
        if user != nil &&  user.isSigned, let name = user.name {
            self.usernameLabel.isHidden = false
            self.usernameLabel.text = name
        } else {
            self.usernameLabel.isHidden = true
        }
    }
    
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}
