//
//  Quotes.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 14/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

struct Quotes {
    
    public func getQuote( completion:@escaping((String, String))->Void) {
        
        guard let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en") else {return}
        URLSession.shared.dataTask(with: url) {(data, respons, error) in
            guard let data = data else{return}
            guard let json = try? JSONDecoder().decode(Quote.self, from: data) else {return}
            DispatchQueue.main.async {
                completion((json.quoteAuthor, json.quoteText))
            }
        }.resume()
    }
}

struct Quote:Decodable {
    let quoteText:String
    let quoteAuthor:String
}
