//
//  UserImageView.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 29/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import SwiftUI

struct UserProfileImage {
    var image:UIImage
}

struct UserImageView: View {
    @State var image:UserProfileImage
//    @ObservedObject var viewController = SettingsViewController()
    private var completion:(UserProfileImage)->Void
    
    init(image:UserProfileImage, completion:@escaping(UserProfileImage)->Void) {
        self._image = State(initialValue: image)
        self.completion = completion
    }
    
    var body: some View {
        Image(uiImage: self.image.image)
        .resizable()
        .frame(width: 240.0, height: 240.0, alignment: .center)
        .clipShape(Circle())
        .shadow(radius: 10)
        .overlay(Circle()
            .stroke(Color.blue,
                    lineWidth: 5))
    }

  
}

//struct UserImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserImageView(viewController: SettingsViewController())
//    }
//}
