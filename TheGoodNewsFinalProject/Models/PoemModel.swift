//
//  PoemModel.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 20/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.

import UIKit

struct PoemModel {
    public func getPoem(completion:@escaping((String, String, String)) ->Void) {
        var poems:[Poem]=[]
        guard let url = URL(string: Constants.urls.poemsAPI) else {return}
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else {return}
            
            guard let json = try? JSONDecoder().decode([Poem].self, from: data) else {return}
            
            for poem in json {
                poems.append(poem)
            }
            DispatchQueue.main.async {
                let randomInt = Int.random(in: 1..<poems.count)
                completion((poems[randomInt].poet,
                            poems[randomInt].title,
                            poems[randomInt].content))
            }
            
        }.resume()
    }
}

struct Poem:Decodable {
    let title:String
    let content:String
    let poet:String
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case poet
    }
    
    enum PoetNameCodingKeys: String, CodingKey {
        case poetName = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let poetContainer = try container.nestedContainer(keyedBy: PoetNameCodingKeys.self, forKey: .poet)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.poet = try poetContainer.decode(String.self, forKey: .poetName)
    }
}
