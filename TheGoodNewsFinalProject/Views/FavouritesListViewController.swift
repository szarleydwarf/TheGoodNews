//
//  FavouritesListViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 18/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class FavouritesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    
    var arrayToDisplayInTable:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch self.segmentController.selectedSegmentIndex {
        case 0:
            self.arrayToDisplayInTable = Favourites().fetchFavourites(view: self.view)
            print("case 0> \(self.arrayToDisplayInTable.count)")
        case 1:
            self.arrayToDisplayInTable = FavouritePoems().fetchPoems(view: self.view)
            print("case 0> \(self.arrayToDisplayInTable.count)")
        case 2:
            self.arrayToDisplayInTable = UserPoemsAndQutes().fetchUserTexts(view: self.view)
            print("case 0> \(self.arrayToDisplayInTable.count)")
        default:
            print("default")
        }
        
    }
    /*
     - load list into table depends on the selected segment
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayToDisplayInTable.count
    }
    
    /*
     - qoute cell just fragment of the qute plus author name - sub
     - poem author and title (part of poem?) - sub
     - user text cell image of Q/P title or quote - regular
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
