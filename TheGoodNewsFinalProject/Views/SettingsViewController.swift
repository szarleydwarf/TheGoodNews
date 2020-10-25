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
    
    let fbAuth = FireBaseController.shared
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var handle:AuthStateDidChangeListenerHandle?
    var email:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear > \(self.email) <> \(fbAuth.fAuth.currentUser)<")
        handle = fbAuth.fAuth.addStateDidChangeListener { (auth, user) in
            if self.email.isEmpty, let email = user?.email {
                self.email = email
            } else if user == nil {
                self.email = ""
            }
        }
        self.changeSignInButtonTitle()
        self.displayUserNameLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fbAuth.fAuth.removeStateDidChangeListener(handle!)
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
        if self.email.isEmpty {
            goToSigningView()
        } else {
            signOut()
        }
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        if self.email.isEmpty {
            Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addTextViewController = storyboard.instantiateViewController(identifier: "AddUserTextViewController") as! AddUserTextViewController
            self.navigationController?.pushViewController(addTextViewController, animated: true)        }
    }
    
    func signOut() {
        do {
            try! fbAuth.fAuth.signOut()
            self.email = ""
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
        let title =  !self.email.isEmpty ? "Sign Out" : "Sign In"
        self.signInButton.setTitle(title, for: .normal)    }
    
    func displayUserNameLabel() {
        if !self.email.isEmpty {
            self.usernameLabel.isHidden = false
            self.usernameLabel.text = self.email
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
