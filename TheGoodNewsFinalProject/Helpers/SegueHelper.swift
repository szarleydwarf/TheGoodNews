//
//  SegueHelper.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 28/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

extension UIStoryboardSegue {
    func forward(_ user: User?, to destination: UIViewController) {
        print("UIStoryboardSegue >\(user?.email)")
        if let navigationController = destination as? UINavigationController {
            let root = navigationController.viewControllers[0]
            forward(user, to: root)
        }
        if let settingsViewController = destination as? SettingsViewController {
            settingsViewController.user = user
        }
        if let poemsVieController = destination as? PoemsViewController {
            poemsVieController.user = user
        }
    }
}
