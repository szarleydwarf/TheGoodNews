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
        guard let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        return imageURL.appendingPathComponent(name + Constants.imageDefaultNames.png)
    }
    
    func imageExists(name:String) ->Bool{
        if let imageURL = imagePath(name: name) {
            if FileManager.default.fileExists(atPath: imageURL.path) {
                return true
            }
        }
        return false
    }
    
    func saveImage(image:UIImage, name:String) -> Bool {
        if let pngData = image.pngData() {
            if let imagePathOnDisc = imagePath(name: name) {
                do {
                    try pngData.write(to: imagePathOnDisc)
                    return true
                } catch let err {
                    print("\(Constants.error.saving) "+err.localizedDescription)
                }
            }
        }
        
        return false
    }
    
    func fetchImage(name:String) -> UIImage? {
        if let imagePathOnDisc = imagePath(name: name) {
            guard let imageData = FileManager.default.contents(atPath: imagePathOnDisc.path) else{return nil}
            return UIImage(data: imageData)
        }
        return nil
    }
}
