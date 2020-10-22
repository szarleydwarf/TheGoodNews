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
import CryptoSwift


class SigningViewController: UIViewController, ASAuthorizationControllerDelegate {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var email:String?
    let user:User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user.email)
            emailTextField.text = passwordItem.account
    }
    
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let newEmail = emailTextField.text, let newPassword = passwordTextField.text , !newEmail.isEmpty && !newPassword.isEmpty else {return}
        let hashedPassword = passwordHash(from: newEmail, password: newPassword)
        
        Auth.auth().createUser(withEmail: newEmail, password: hashedPassword) { authResult, error in
            Toast().showToast(message: "Hello \(newEmail)", font: .systemFont(ofSize: 18), view: self.view)
            self.user.setUserInUserDefaults(email: newEmail)

        }
        do {
            if let originalEmail = self.email {
                var paswordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: originalEmail)
                
                try paswordItem.renameAccount(newEmail)
                try paswordItem.savePassword(hashedPassword)
            } else {
                let paswordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: newEmail)
                try paswordItem.savePassword(hashedPassword)
            }
        } catch let error{
            Toast().showToast(message: "Error creating account \(error)", font: .systemFont(ofSize: 16), view: self.view)
        }
        jumpToSettingsView()
    }
    
    func jumpToSettingsView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    func passwordHash(from email: String, password: String) -> String {
        let salt = "x4vV8bGgqqmQw974yriksdbckbq9ipidk;jgCoyXFQj+(o.nP7ND"
        return "\(password).\(email).\(salt)".sha256()
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
