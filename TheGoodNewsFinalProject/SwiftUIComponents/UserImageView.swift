//
//  UserImageView.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 29/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import SwiftUI

struct UserImageView: View {
    @State var image:UIImage = UIImage(imageLiteralResourceName: "profile")
    
    var body: some View {
        Image(uiImage: image)
        .resizable()
        .frame(width: 240.0, height: 240.0, alignment: .center)
        .clipShape(Circle())
        .shadow(radius: 10)
        .overlay(Circle()
            .stroke(Color.blue,
                    lineWidth: 5))
    }
}
