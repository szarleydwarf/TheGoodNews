//
//  CoreDataController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 14/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
    private init() {    }
    
    static let shared = CoreDataController()
    
    var mainCtx: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.coredata.persistentContainarName)
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("\(Constants.error.persistentContainer) \(error)")
            }
        })
        return container
    }()
    
    func save() -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
                return true
            } catch{
                let nserror = error as NSError
                fatalError("\(Constants.error.saving) \(nserror)")
            }
        }
        
        return false
    }
}
