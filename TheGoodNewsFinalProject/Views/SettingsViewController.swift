//
//  SettingsViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 15/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import GoogleMobileAds
import UIKit
import SwiftUI
import CoreData
import Kingfisher
import Firebase

class SettingsViewController: UIViewController, ObservableObject, ImagePickerHelperDelegate {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editUserImageButton: UIButton!
    @IBOutlet weak var addingUserTextButton: UIButton!
    @IBOutlet weak var syncFromFirebaseButton: UIButton!
    @IBOutlet weak var syncIntoFireBaseButton: UIButton!
    
    let fbAuth = FireBaseController.shared
    
    var googleAdsManager = GoogleAdsManager()
    var banner:GADBannerView!
    var handle:AuthStateDidChangeListenerHandle?
    var imagePicker:ImagePickerHelper!
    var email:String = ""
    var user:User?
    var container:NSPersistentContainer?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.container = CoreDataController.shared.persistentContainer
        
        handle = fbAuth.fAuth.addStateDidChangeListener { (auth, user) in
            if let user = self.user {
                self.email = user.email
                self.changeSignInButtonTitle()
                self.toggleElementsVisibility()
                self.toggleElementTint()
                self.setUserProfileImageInImageView()
            } else if self.email.isEmpty, let email = user?.email {
                self.email = email
                self.changeSignInButtonTitle()
                self.toggleElementsVisibility()
                self.toggleElementTint()
                self.setUserProfileImageInImageView()
            } else if user == nil {
                self.email = ""
            }
        }
        
        guard let container = self.container else {return}
        container.loadPersistentStores{ storeDescription, error in
            print("SETTINGS viewWillAppear >>\(storeDescription)>><<\(error)")
            guard let container = self.container else {return}
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fbAuth.fAuth.removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePickerHelper(presentationController: self, delegate: self)
        
        setUserProfileImageView()
        setBanner()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        banner.frame = googleAdsManager.getBannerSize(size: view.frame.size).integral
    }
    
    @IBAction func showFavourites(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favouritesViewController = storyboard.instantiateViewController(identifier: "FavouritesListViewController") as! FavouritesListViewController
        self.navigationController?.pushViewController(favouritesViewController, animated: true)
    }
    
    @IBAction func signinOptions(_ sender: UIButton) {
        if self.email.isEmpty  {
            goToSigningView()
        } else {
            signOut()
        }
    }
    
    @IBAction func changeUserImage(_ sender: UIButton) {
        print("CHANGING USER IMAGE")
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func addQuoteOrPoem(_ sender: UIButton) {
        if self.email.isEmpty {
            Toast().showToast(message: "You need to sign in to add your quote or poem", font: .systemFont(ofSize: 22.0), view: self.view)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addTextViewController = storyboard.instantiateViewController(identifier: "AddUserTextViewController") as! AddUserTextViewController
            self.navigationController?.pushViewController(addTextViewController, animated: true)        }
    }
    
    @IBAction func syncToFireDataBase(_ sender: UIButton) {
        if self.email.isEmpty {
            Toast().showToast(message: "You need to sign in to Sync your data", font: .systemFont(ofSize: 22.0), view: self.view)
        } else {
            Toast().showToast(message: "Starting to syncing your favourites to cloud allow some time to finish", font: .systemFont(ofSize: 22.0), view: self.view)
            var toastMessage:String = ""
            
            self.quoteSync{ message in
                toastMessage += message
            }
            self.poemSync{ message in
                toastMessage += message
            }
            self.userTextSync{message in
                toastMessage += message
            }
            if !toastMessage.isEmpty{
                Toast().showToast(message: toastMessage, font: .systemFont(ofSize: 16), view: self.view)
            }
        }
    }
    
    @IBAction func syncToCoreData(_ sender: UIButton) {
        if self.email.isEmpty {
            Toast().showToast(message: "You need to sign in to sync your data", font: .systemFont(ofSize: 22.0), view: self.view)
        } else {
            Toast().showToast(message: "Starting to syncing your favourites to device allow some time to finish", font: .systemFont(ofSize: 22.0), view: self.view)
            let quotesList = Favourites().fetchFavourites(view: self.view, userEmail: self.email)
            FirebaseCoreDataSync().syncQuotesIntoCoreData(favouriteQuotesList: quotesList) {
                completed in
                if completed {
                    Toast().showToast(message: "Qoutes synced to local drive", font: .systemFont(ofSize: 16), view: self.view)
                }
            }
            let poemList = FavouritePoems().fetchPoems(view: self.view, userEmail: self.email)
            FirebaseCoreDataSync().syncPoemsIntoCoreData(favouritePoemsList: poemList) { completed in
                if completed {
                    Toast().showToast(message: "Poems sync completed", font: .systemFont(ofSize: 16), view: self.view)
                }
            }
            
            let userTextList = UserPoemsAndQutes().fetchUserTexts(view: self.view, userEmail: self.email)
            FirebaseCoreDataSync().syncUserTextIntoCoreData(userTextList: userTextList) {completed in
                if completed {
                    Toast().showToast(message: "\(self.user?.name ?? ""), Your texts sync complete", font: .systemFont(ofSize: 16), view: self.view)
                }
            }
        }
    }
    
    @IBAction func unvindToSettings(_ sender: UIStoryboardSegue) {}
    
    func quoteSync(completion:@escaping(String) -> Void){
        let quotesToSync = Favourites().fetchFavourites(view: self.view, userEmail: self.email)
        if quotesToSync.count > 0 {
            FirebaseCoreDataSync().syncQuotesToFireDataBase(favouriteQuotesList: quotesToSync) { completed in
                if completed {
                    completion("QUOTES SYNCED ")
                }
            }
        }
    }
    
    func poemSync(completion:@escaping(String) -> Void){
        let poemsToSync = FavouritePoems().fetchPoems(view: self.view, userEmail: self.email)
        if poemsToSync.count > 0 {
            FirebaseCoreDataSync().syncPoemsToFireDataBase(favouritePoemsList: poemsToSync) { completed in
                if completed {
                    completion( "POEMS SYNCED")
                }
            }
        }
    }
    
    func userTextSync(completion:@escaping(String) -> Void) {
        let userTextToSync = UserPoemsAndQutes().fetchUserTexts(view: self.view, userEmail: self.email)
        if userTextToSync.count > 0 {
            FirebaseCoreDataSync().syncUserTextToFireDataBase(userTextList: userTextToSync){ completed in
                if completed {
                    completion("\(self.user?.name ?? ""), Your texts are updated")
                }
            }
        }
    }
    
    func signOut() {
        do {
            try fbAuth.fAuth.signOut()
            self.user = nil
            self.email = ""
            self.changeSignInButtonTitle()
            self.toggleElementsVisibility()
            self.toggleElementTint()
        } catch let err{
            Toast().showToast(message: "could not sign out \(err)", font: .systemFont(ofSize: 16), view: self.view)
        }
    }
    
    func goToSigningView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SigningViewController") as! SigningViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeSignInButtonTitle () {
        let title =  !self.email.isEmpty ? "Sign Out" : "Sign In"
        self.signInButton.setTitle(title, for: .normal)
    }
    
    func toggleElementsVisibility() {
        if !self.email.isEmpty {
            self.usernameLabel.isHidden = false
            self.usernameLabel.text = UserHelper().getUserName(email: self.email)
            self.editUserImageButton.isHidden = false
        } else {
            self.usernameLabel.isHidden = true
            self.editUserImageButton.isHidden = true
            self.userImageView.image = UIImage(imageLiteralResourceName: "profile")
        }
    }
    
    func toggleElementTint () {
        if !self.email.isEmpty {
            self.syncFromFirebaseButton.tintColor = .systemOrange
            self.syncIntoFireBaseButton.tintColor = .systemOrange
            self.addingUserTextButton.tintColor = .systemOrange
        } else {
            self.syncFromFirebaseButton.tintColor = .systemGray
            self.syncIntoFireBaseButton.tintColor = .systemGray
            self.addingUserTextButton.tintColor = .systemGray
        }
    }
    
    func setUserProfileImageInImageView() {
        var profileImage:UIImage?
        if FileStoringHelper().imageExists(name: self.email){
            profileImage = FileStoringHelper().fetchImage(name: self.email)
        } else {
            profileImage = UIImage(named: "profile")
        }
        self.userImageView.image = profileImage
    }
    
    func setBanner() {
        self.banner = googleAdsManager.getBanner()
        banner.rootViewController = self
        view.addSubview(banner)
    }
    
    func setUserProfileImageView() {
        self.userImageView.layer.borderWidth = 1.0
        self.userImageView.layer.masksToBounds = false
        self.userImageView.layer.borderColor = UIColor.white.cgColor
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2
        self.userImageView.clipsToBounds = true
        self.userImageView.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        self.userImageView.contentMode = UIView.ContentMode.scaleAspectFill
        
    }
    
    func didSelect(image: UIImage?) {
        if let imageToDisplay = image{
            self.userImageView.image = imageToDisplay
            if FileStoringHelper().saveImage(image: imageToDisplay, name: self.email) {
                Toast().showToast(message: "Image Saved", font: .systemFont(ofSize: 18.0), view: self.view)
            }
        }
    }
}
