//
//  UserImageView.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 29/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import SwiftUI

struct UserImageViewModel: UIViewRepresentable {
    @Binding var image: UIImage

    func makeUIView(context: Context) -> UIImageView {
        return UIImageView()
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = image
    }
}

struct UserImageView: View {
    @State var image:UIImage = UIImage(imageLiteralResourceName: "profile")
    
    
    var body: some View {
        UserImageViewModel(image: $image)
        .clipShape(Circle())
        .shadow(radius: 10)
        .overlay(Circle()
            .stroke(Color.blue,
                    lineWidth: 5))
    }

    func changeImage() {
        
    }
    
}
