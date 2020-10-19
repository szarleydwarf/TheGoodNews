//
//  FavouritePoems.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 19/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData

class FavouritePoems {
    let coreDataController = CoreDataController.shared
    
    func fetchPoems(view: UIView) -> [Poems] {
        var poems:[Poems] = []
        let ctx = coreDataController.mainCtx
        let request: NSFetchRequest<Poems> = Poems.fetchRequest()
        do {
            poems = try ctx.fetch(request)
        } catch let err {
            Toast().showToast(message: "Error fetching poems \(err)", font: .systemFont(ofSize: 15), view:  view)
        }
        return poems
    }
    
    func savePoem() {
        
    }
    
    func deletePoem() {
        
    }
    
    func checkIfFavourite() {
        
    }
}
