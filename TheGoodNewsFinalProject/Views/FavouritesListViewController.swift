//
//  FavouritesListViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 18/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

enum ElementType {
    case quote, poem, userText
}

class FavouritesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    
    var arrayToDisplayInTable:[Any] = []
    var typeToCompare:ElementType?
    let cellIdentifier:String = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self
        self.table.delegate = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.arrayToDisplayInTable = Favourites().fetchFavourites(view: self.view)
        print("viewDidLoad> \(self.arrayToDisplayInTable.count) ")
        self.table.reloadData()
    }
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.arrayToDisplayInTable = []
        switch self.segmentController.selectedSegmentIndex {
        case 0:
            self.arrayToDisplayInTable = Favourites().fetchFavourites(view: self.view)
            typeToCompare = ElementType.quote
            print("case 0> \(self.arrayToDisplayInTable.count)")
        case 1:
            self.arrayToDisplayInTable = FavouritePoems().fetchPoems(view: self.view)
            typeToCompare = ElementType.poem
            print("case 1> \(self.arrayToDisplayInTable.count)")
        case 2:
            self.arrayToDisplayInTable = UserPoemsAndQutes().fetchUserTexts(view: self.view)
            typeToCompare = ElementType.userText
            print("case 2> \(self.arrayToDisplayInTable.count)")
        default:
            print("default")
        }
        for el in self.arrayToDisplayInTable {
            print("ELEMENT > \(el)")
        }
        self.table.reloadData()
    }
    
    func updateCell(cell:UITableViewCell, element:Any){
        if !self.arrayToDisplayInTable.isEmpty {
            switch typeToCompare {
            case .quote:
                let quote = element as! Favourite
                print("QUOTES \(quote.author); \(quote.quote)")
                cell.textLabel?.text = quote.author
                cell.detailTextLabel?.text = quote.quote
                 cell.imageView?.image = UIImage.init(named: "q")

            case .poem:
                let poem = element as! Poems
                if let author = poem.author, let title = poem.title {
                    print("POEMS \(author)")
                cell.textLabel?.text = author + " - " + title
                }
                cell.imageView?.image = UIImage.init(named: "p")

            case .userText:
                let text = element as! UserQuotePoems
                print("USER TEXT")
                cell.textLabel?.text = text.text
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
    
    /*
     - qoute cell just fragment of the qute plus author name - sub
     - poem author and title (part of poem?) - sub
     - user text cell image of Q/P title or quote - regular
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellIdentifier)
        }
        
        updateCell(cell: cell, element: self.arrayToDisplayInTable[indexPath.row])
        
        return cell
    }
}
