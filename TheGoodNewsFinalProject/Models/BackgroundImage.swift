//
//  BackgroundImage.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 13/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation


struct BackgroundImages: Decodable {
    let hits:[BackgroundImage]
}

struct BackgroundImage:Decodable {
//    let id:Int
    let webformatURL:URL
}
