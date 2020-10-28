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
    let toastFontSize:CGFloat = 16.0
    
    var user:User?
    var name:String?
    var hashedPassword:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signIn(_ sender: UIButton) {
    }
    
    func fetchUserFromFields() -> Bool {
        guard let newEmail = emailTextField.text, let newPassword = passwordTextField.text , !newEmail.isEmpty && !newPassword.isEmpty else {
            Toast().showToast(message: "Enter email and password to sign in", font: .systemFont(ofSize: 18), view: self.view)
            return false
        }
        self.hashedPassword = UserHelper().hashThePassword(from: newEmail, password: newPassword)
        let name = UserHelper().getUserName(email: newEmail)
        self.user = User.init(email: newEmail, name: name)
        Toast().showToast(message: "Hello \(name). Thank you for signing in. You will be redirected in 4s.", font: .systemFont(ofSize: self.toastFontSize), view: self.view)

        return true
    }
    
    func createLocalUser(email: String, password: String) {
        if !UserHelper().userExistInKeyChain(email: email) {
            UserHelper().saveUserToKeyChain(view: self.view, email: email, password: UserHelper().getUserName(email: email))
        }
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
                self.createLocalUser(email: email, password: password)
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
                self.createLocalUser(email: email, password: password)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userFetched = fetchUserFromFields()
        ConnectionHelper().connected{connected in
            guard let email = self.user?.email else {return}
            guard let password = self.hashedPassword else {return}
            print("SIGNIN connection  >\(email)")
            if connected {
                //connection try connect with firebase
                self.createNewUser(email:email, password:password)
            } else {
                //no connection try to login with keychain
                self.createLocalUser(email: email, password: password)
            }
        }
        //in both cases try to update the other source
        if userFetched {
            segue.forward(self.user, to: segue.destination)
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
