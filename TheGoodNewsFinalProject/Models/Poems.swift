//
//  Poems.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 20/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

struct Poems {
    public func getPoem(completion: @escaping(String, String, String)) ->Void {
        guard let url = URL(string: "") else {return}
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data
            
        }.resume()
    }
}

struct Poem:Decodable {
    let title:String
    let content:String
    let poet:Poet
    /*
     {
     "title": "Each Thorn Was Crying",
     "content": "Sometimes I will interplay\nthe secrets: \nfaded rose in a book, \na distant star spelling out\nyour name.\n\nWhen I go, will you come\nto my home? \nHold my eyes wide open\nand become my iris? \nI wanted to see the innocence of a sin.\n\nBlack stone on a white belly\npetrifies the womb.\nManiacs were dancing on the petals\nof marigolds.\nA mauve revenge\n\nPetit mal holds the sanity\nof defeat.\nPheromones will decide the gender\nof a flat chested angel.\nEach thorn was crying.",
     "poet": {
         "name": "Satish Verma",
     }
     */
}

struct Poet {
    let name:String
}
