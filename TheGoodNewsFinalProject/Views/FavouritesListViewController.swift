//
//  FavouritesListViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 18/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import GoogleMobileAds

enum ElementType {
    case quote, poem, userText
}

class FavouritesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    
    var arrayToDisplayInTable:[Any] = []
    var typeToCompare:ElementType?
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    let cellIdentifier:String = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.arrayToDisplayInTable = Favourites().fetchFavourites(view: self.view, userEmail: User().email)
        typeToCompare = .quote
        self.table.reloadData()
        setBanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.arrayToDisplayInTable = []
        switch self.segmentController.selectedSegmentIndex {
        case 0:
            self.arrayToDisplayInTable = Favourites().fetchFavourites(view: self.view, userEmail: User().email)
            typeToCompare = ElementType.quote
        case 1:
            self.arrayToDisplayInTable = FavouritePoems().fetchPoems(view: self.view, userEmail: User().email)
            typeToCompare = ElementType.poem
        case 2:
            self.arrayToDisplayInTable = UserPoemsAndQutes().fetchUserTexts(view: self.view, userEmail: User().email)
            typeToCompare = .userText
        default:
            print("default")
        }
        self.table.reloadData()
    }
    
    func updateCell(cell:UITableViewCell, element:Any){
        if !self.arrayToDisplayInTable.isEmpty {
            switch typeToCompare {
            case .quote:
                let quote = element as! Favourite
                cell.textLabel?.text = quote.author
                cell.detailTextLabel?.text = quote.quote
                cell.imageView?.image = UIImage.init(named: "q")
                
            case .poem:
                let poem = element as! Poems
                if let author = poem.author, let title = poem.title {
                    cell.textLabel?.text = author + " - " + title
                }
                cell.imageView?.image = UIImage.init(named: "p")
                
            case .userText:
                let text = element as! UserQuotePoems
                cell.textLabel?.text = text.text
                cell.detailTextLabel?.text = User().name
                let imageName = (text.isQuote) ? "p" : "q"
                cell.imageView?.image = UIImage.init(named: imageName)
            default:
                print("QUOTES")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayToDisplayInTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellIdentifier)
        }
        
        updateCell(cell: cell, element: self.arrayToDisplayInTable[indexPath.row])
        
        return cell
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
}
