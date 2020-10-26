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
    let fbAuth = FireBaseController.shared
    let user = User.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let newEmail = emailTextField.text, let newPassword = passwordTextField.text , !newEmail.isEmpty && !newPassword.isEmpty else {
            Toast().showToast(message: "Enter email and password to sign in", font: .systemFont(ofSize: 18), view: self.view)
            return
        }
        let hashedPassword = UserHelper().hashThePassword(from: newEmail, password: newPassword)
        
        //test connection
        ConnectionHelper().connected{connected in
            print("SigningViewController \(connected)")
            if connected {
                self.createNewUser(email:newEmail, password:hashedPassword)
            } else {
                self.createLocalUser(email: newEmail, password: hashedPassword)
            }
        }
        //no connection try to login with keychain
        //connection try connect with firebase
        //in both cases try to update the other source
        
    }
    
    func createLocalUser(email: String, password: String) {
        if !UserHelper().userExistInKeyChain(email: email) {
            UserHelper().saveUserToKeyChain(view: self.view, email: email, password: UserHelper().getUserName(email: email))
        }
        user.name = UserHelper().getUserName(email: email)
        user.email = email
    }
    
    func createNewUser(email:String, password:String) {
        fbAuth.fAuth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .emailAlreadyInUse:
                    // Error: The email address is already in use by another account.
                    self.signMeIn(email: email, password: password)
                case .invalidEmail:
                    // Error: The email address is badly formatted.
                    Toast().showToast(message: "Bad email format", font: .systemFont(ofSize: 18), view: self.view)
                case .weakPassword:
                    // Error: The password must be 6 characters long or more.
                    Toast().showToast(message: "The password must be at least 6 characters long", font: .systemFont(ofSize: 18), view: self.view)
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
//                let newUserInfo = self.fbAuth.fAuth.currentUser
//                var name = ""
//                if let email = newUserInfo?.email {
                let name = UserHelper().getUserName(email: email)
//                }
                self.createLocalUser(email: email, password: password)
                Toast().showToast(message: "Hello \(name). Thank you for signing in", font: .systemFont(ofSize: 18), view: self.view)
                self.jumpToSettingsView()
            }
        }
    }
    
    func signMeIn(email:String, password:String) {
        print("User signsMEIN func")
        
        fbAuth.fAuth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    Toast().showToast(message: "Your account was blocked. Contact us for details", font: .systemFont(ofSize: 18), view: self.view)
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    Toast().showToast(message: "The password does not match the one we have saved", font: .systemFont(ofSize: 18), view: self.view)
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    Toast().showToast(message: "Bad email", font: .systemFont(ofSize: 18), view: self.view)
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
//                let userInfo =
//                    self.fbAuth.fAuth.currentUser
//                var name = ""
//                if let email = userInfo?.email {
                  let  name = UserHelper().getUserName(email: email)
//                }
                self.createLocalUser(email: email, password: password)

                Toast().showToast(message: "Hello \(name). Thank you for signing in", font: .systemFont(ofSize: 18), view: self.view)
                self.jumpToSettingsView()
            }
        }
    }
    
    func jumpToSettingsView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + (Toast().animationDuration - 1.5), execute: {
            self.navigationController?.popViewController(animated: true)
        })
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
