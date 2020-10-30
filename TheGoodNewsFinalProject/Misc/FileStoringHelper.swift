//
//  FileStoringHelper.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 30/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class FileStoringHelper {
    
    func imagePath(name:String) -> URL? {
        let fileManager = FileManager.default
        guard let imageURL = fileManager.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {return nil}
        return imageURL.appendingPathComponent(name + ".png")
    }
    
    func saveImage(image:UIImage, name:String) -> Bool {
        if let pngData = image.pngData() {
            if let imagePathOnDisc = imagePath(name: name) {
                do {
                    try pngData.write(to: imagePathOnDisc, options: .atomic)
                } catch let err {
                    print("Saving faild with error: "+err.localizedDescription)
                }
            }
        }
        
        return false
    }
    
    func fetchImage(name:String, url:URL) -> UIImage? {
        if let imagePathOnDisc = imagePath(name: name) {
            guard let imageData = FileManager.default.contents(atPath: imagePathOnDisc.path) else{return nil}
            return UIImage(data: imageData)
        }
        return nil
    }
}
