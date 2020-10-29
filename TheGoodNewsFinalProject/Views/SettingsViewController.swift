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

class SettingsViewController: UIViewController, ImagePickerHelperDelegate {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editUserImageButton: UIButton!
    
    let fbAuth = FireBaseController.shared
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var handle:AuthStateDidChangeListenerHandle?
    var imagePicker:ImagePickerHelper!
    var email:String = ""
    var user:User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SettingsViewController > \(self.email) <> \(fbAuth.fAuth.currentUser)< \(user?.name)> \(user?.email) <<<")
        
        handle = fbAuth.fAuth.addStateDidChangeListener { (auth, user) in
            if let user = self.user {
                self.email = user.email
                self.changeSignInButtonTitle()
                self.toggleElementsVisibility()
            } else if self.email.isEmpty, let email = user?.email {
                self.email = email
                self.changeSignInButtonTitle()
                self.toggleElementsVisibility()
            } else if user == nil {
                self.email = ""
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fbAuth.fAuth.removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
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
        if self.email.isEmpty  {
            goToSigningView()
        } else {
            signOut()
        }
    }
    
    @IBAction func changeUserImage(_ sender: UIButton) {
        print("CHANGING USER IMAGE")
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        if self.email.isEmpty {
            Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addTextViewController = storyboard.instantiateViewController(identifier: "AddUserTextViewController") as! AddUserTextViewController
            self.navigationController?.pushViewController(addTextViewController, animated: true)        }
    }
    
    @IBAction func unvindToSettings(_ sender: UIStoryboardSegue) {}
    
    func signOut() {
        do {
            try fbAuth.fAuth.signOut()
            self.user = nil
            self.email = ""
            changeSignInButtonTitle()
            toggleElementsVisibility()
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
        self.signInButton.setTitle(title, for: .normal)
    }
    
    func toggleElementsVisibility() {
        if !self.email.isEmpty {
            self.usernameLabel.isHidden = false
            self.usernameLabel.text = UserHelper().getUserName(email: self.email)
            self.editUserImageButton.isHidden = false
            self.editUserImageButton.isEnabled = true
        } else {
            self.usernameLabel.isHidden = true
            self.editUserImageButton.isHidden = true
            self.editUserImageButton.isEnabled = false
        }
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    func didSelect(image: UIImage?) {
        self.userImageView.image = image
    }
}
