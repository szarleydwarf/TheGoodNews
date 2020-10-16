//
//  SigningViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 16/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import AuthenticationServices

class SigningViewController: UIViewController, ASAuthorizationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSignInAppleButton()
    }
    
    func setUpSignInAppleButton() {
      let authorizationButton = ASAuthorizationAppleIDButton()
      authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
      authorizationButton.cornerRadius = 10
      //Add button on some view or stack
      self.signInButtonStack.addArrangedSubview(authorizationButton)
    }
    
    @objc func handleAppleIdRequest() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
    let userIdentifier = appleIDCredential.user
    let fullName = appleIDCredential.fullName
    let email = appleIDCredential.email
        print("""
            User id is \(userIdentifier)
            \n Full Name is \(String(describing: fullName))
            \n Email id is \(String(describing: email))
            """)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
}
}
