//
//  SigningViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 16/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices


class SigningViewController: UIViewController, ASAuthorizationControllerDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var email:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = self.email {
            do{
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: email)
                emailTextField.text = passwordItem.account
                passwordTextField.text = try passwordItem.readPassword()
            } catch let error {
                Toast().showToast(message: "Error getting password \(error)", font: .systemFont(ofSize: 16), view: self.view)
            }
        }
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let newEmail = emailTextField.text, let newPassword = passwordTextField.text , !newEmail.isEmpty && !newPassword.isEmpty else {return}
        
        
            Auth.auth().createUser(withEmail: newEmail, password: newPassword) { authResult, error in
                Toast().showToast(message: "Hello \(newEmail)  \n \(authResult)", font: .systemFont(ofSize: 18), view: self.view)
                
            }
        do {
            if let originalEmail = self.email {
                var paswordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: originalEmail)
                
                try paswordItem.renameAccount(newEmail)
                try paswordItem.savePassword(newPassword)
            } else {
                let paswordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: newEmail)
                try paswordItem.savePassword(newPassword)
            }
        } catch let error{
           Toast().showToast(message: "Error creating account \(error)", font: .systemFont(ofSize: 16), view: self.view)
        }
        
    }
    
    /*
     To be implemented in future
     */
    /*
     func setupProviderLoginView() {
     let authorizationButton = ASAuthorizationAppleIDButton()
     authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
     self.view.addSubview(authorizationButton)
     }
     
     @objc
     func handleAuthorizationAppleIDButtonPress() {
     let appleIDProvider = ASAuthorizationAppleIDProvider()
     let request = appleIDProvider.createRequest()
     request.requestedScopes = [.fullName, .email]
     
     let authorizationController = ASAuthorizationController(authorizationRequests: [request])
     authorizationController.delegate = self
     authorizationController.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
     authorizationController.performRequests()
     }
     
     func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
     switch authorization.credential {
     case let appleIDCredential as ASAuthorizationAppleIDCredential:
     
     // Create an account in your system.
     let userIdentifier = appleIDCredential.user
     let fullName = appleIDCredential.fullName
     let email = appleIDCredential.email
     
     // For the purpose of this demo app, store the `userIdentifier` in the keychain.
     //            self.saveUserInKeychain(userIdentifier)
     
     // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
     //            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
     
     case let passwordCredential as ASPasswordCredential:
     
     // Sign in using an existing iCloud Keychain credential.
     let username = passwordCredential.user
     let password = passwordCredential.password
     
     // For the purpose of this demo app, show the password credential as an alert.
     DispatchQueue.main.async {
     //                self.showPasswordCredentialAlert(username: username, password: password)
     }
     
     default:
     break
     }
     }
     */
}
