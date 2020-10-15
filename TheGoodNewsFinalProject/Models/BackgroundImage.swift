//
//  BackgroundImage.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 13/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Kingfisher

struct Backgrounds {
    public func getBackgroundImage(completion:@escaping((URL))->Void) {
        var backgrounds:[URL] = []
        guard let url = URL(string: "https://pixabay.com/api/?key=18691967-c6bbf9bfa8dba2ffd4c907bb5&q=beautiful+landscape&image_type=photo") else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else{return}
            guard let results = try? JSONDecoder().decode(BackgroundImages.self, from: data) else {return}
            for hit in results.hits {
                backgrounds.append(hit.webformatURL)
            }
            DispatchQueue.main.async {
                let randomInt = Int.random(in: 1..<backgrounds.count)
                completion(backgrounds[randomInt])
            }
            
        }.resume()
    }
}

struct BackgroundImages: Decodable {
    let hits:[BackgroundImage]
}

struct BackgroundImage:Decodable {
    let webformatURL:URL
}
