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
    var email:String?
    var isSigned:Bool = false
    let userDefaults = UserDefaults.standard
    let stringEmail = "email"
    
    @IBOutlet weak var userImageView: UIImageView!
    /*
     - sign in with apple (fb?, google?)
     - choose user image
     - save signing into keychain
     - ads quote button check f signin to enable
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email = userDefaults.string(forKey: stringEmail)
        print("SETTINGS EMAIL > \(email) \(userDefaults.string(forKey: stringEmail))")
        setBanner()
        isUserSigned()
        displayUserNameLabel()
        changeSignInButtonTitle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func showFavourites(_ sender: UIButton) {
        print("TO BE IMLEMENTED SOON")
    }
    
    @IBAction func signinOptions(_ sender: UIButton) {
        //change sign in to sign off
        if !self.isSigned {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            do {
                try Auth.auth().signOut()
                self.isSigned = false
            } catch let err{
                Toast().showToast(message: "could not sign out \(err)", font: .systemFont(ofSize: 16), view: self.view)
            }
        }
        self.reloadData()
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        print("TO BE IMLEMENTED SOON")
        if self.isSigned {
            //            self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
        } else{
            Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
        }
    }
    
    func reloadData() {
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
    }
    
    func changeSignInButtonTitle () {
        let title =  self.isSigned ? "Sign Out" : "Sign In"
        self.signInButton.setTitle(title, for: .normal)
    }
    
    func displayUserNameLabel() {
        if self.isSigned {
            self.usernameLabel.isHidden = false
            self.usernameLabel.text = self.email
        } else {
            self.usernameLabel.isHidden = true
        }
    }
    
    func isUserSigned() {
        if let email = self.email {
            do {
                do {
                    let password = try KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email).readPassword()
                    self.isSigned =  password.count > 0 ? true : false
                } catch {
                    self.isSigned = false
                }
            }
            catch {
                fatalError("Error reading password from keychain - \(error)")
            }
        }
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}
