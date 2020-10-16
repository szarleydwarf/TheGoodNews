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

class SettingsViewController: UIViewController {
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        print("TO BE IMLEMENTED SOON")
        if self.isSigned {
//            self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
        } else{
            Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
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
