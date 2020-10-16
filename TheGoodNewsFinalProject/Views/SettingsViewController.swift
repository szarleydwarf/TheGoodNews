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
    
    @IBOutlet weak var userImageView: UIImageView!
    /*
     - sign in with apple (fb?, google?)
     - choose user image
     - save signing into keychain
     - ads quote button check f signin to enable
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        print("TO BE IMLEMENTED SOON")
         Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
    }
    
    func isUserSigned() {
        if let email = self.email {
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email, accessGroup: KeychainConfiguration.accessGroup)
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
