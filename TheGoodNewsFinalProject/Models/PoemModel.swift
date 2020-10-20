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
        guard let url = URL(string: "https://www.poemist.com/api/v1/randompoems") else {return}
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data else {return}
            do {
                guard let json = try? JSONDecoder().decode([Poem].self, from: data) else {return}
                
                print("JSON POEM > \(json.count)")
                for poem in json {
                    poems.append(poem)
                }
                DispatchQueue.main.async {
                    let randomInt = Int.random(in: 1..<poems.count)
                    completion((poems[randomInt].poet,
                                poems[randomInt].title,
                                poems[randomInt].content))
                }
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }.resume()
    }
}
/*
 {
 "title": "Each Thorn Was Crying",
 "content": "Sometimes I will interplay\nthe secrets: \nfaded rose in a book, \na distant star spelling out\nyour name.\n\nWhen I go, will you come\nto my home? \nHold my eyes wide open\nand become my iris? \nI wanted to see the innocence of a sin.\n\nBlack stone on a white belly\npetrifies the womb.\nManiacs were dancing on the petals\nof marigolds.\nA mauve revenge\n\nPetit mal holds the sanity\nof defeat.\nPheromones will decide the gender\nof a flat chested angel.\nEach thorn was crying.",
 "poet": {
 "name": "Satish Verma",
 }
 */
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
