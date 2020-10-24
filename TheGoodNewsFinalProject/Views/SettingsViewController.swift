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
    var handle:AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let email = user?.email{
                self.user = User(email: email, isSigned: true)
            }
            self.changeSignInButtonTitle()
            self.displayUserNameLabel()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBanner()
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
        if self.user == nil || !self.user.isSigned {
            goToSigningView()
        } else {
            signOut()
        }
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        if self.user == nil || !self.user.isSigned {
            Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addTextViewController = storyboard.instantiateViewController(identifier: "AddUserTextViewController") as! AddUserTextViewController
            self.navigationController?.pushViewController(addTextViewController, animated: true)        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            changeSignInButtonTitle()
            displayUserNameLabel()
        } catch let err{
            Toast().showToast(message: "could not sign out \(err)", font: .systemFont(ofSize: 16), view: self.view)
        }
    }
    
    func goToSigningView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeSignInButtonTitle () {
        var title = "Sign In"
        if user != nil {
            title =  user.isSigned ? "Sign Out" : "Sign In"
        }
        self.signInButton.setTitle(title, for: .normal)    }
    
    func displayUserNameLabel() {
        if self.user != nil {
            if self.user.isSigned, let name = self.user.name {
                self.usernameLabel.isHidden = false
                self.usernameLabel.text = name
            } else if !self.user.isSigned {
                self.usernameLabel.isHidden = true
            }
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
