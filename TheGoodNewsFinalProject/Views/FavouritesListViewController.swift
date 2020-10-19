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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /*
      - load list into table depends on the selected segment
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
