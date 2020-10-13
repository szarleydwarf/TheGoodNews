//
//  ViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 13/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//
import GoogleMobileAds
import UIKit
import Kingfisher


class ViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var instagramShareButton: UIButton!
    @IBOutlet weak var facebookShareButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var backgrounds:[BackgroundImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBanner()
        getBackgroundImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    func getBackgroundImage() {
        guard let url = URL(string: "https://pixabay.com/api/?key=18691967-c6bbf9bfa8dba2ffd4c907bb5&q=beautiful+landscape&image_type=photo") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{return}
            guard let results = try? JSONDecoder().decode(BackgroundImages.self, from: data) else {return}
            for hit in results.hits {
                self.backgrounds.append(hit)
                print("JSON> \(hit)")
            }
//            print("data> \(data)")
//            print("resp> \(response)")
//            print("erro> \(error)")
            
        }.resume()
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}

