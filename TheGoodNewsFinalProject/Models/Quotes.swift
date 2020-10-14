//
//  Quotes.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 14/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

struct Quotes {
    
    public func getQuote(quoteLabel:UILabel, authorLabel: UILabel) {
        
        guard let url = URL(string: "https://quotesondesign.com/wp-json/wp/v2/posts/?orderby=rand") else {return}
        URLSession.shared.dataTask(with: url) {(data, respons, error) in
            guard let data = data else{return}
            guard let json = try? JSONDecoder().decode(Quote.self, from: data) else {return}
            print("DATA > \(data)")
            print("JSON > \(json)")
            print("ERRO > \(error)")
            
        }.resume()
    }
}
/*
 "title": {
     "rendered": "Piet Zwart"
 },
 "content": {
     "rendered": "<p>The more uninteresting the letter, the more useful it is to the typographer.  </p>\n",
     "protected": false
 },
 */

struct Quote:Decodable {
    let title:Title
    let content:Content
}

struct Title:Decodable {
    let rendered:String
}

struct Content:Decodable {
    let rendered:String
    let protected:Bool
}
