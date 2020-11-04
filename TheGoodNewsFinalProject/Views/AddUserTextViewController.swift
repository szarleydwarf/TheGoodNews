//
//  AddUserTextViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 17/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase

class AddUserTextViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var quotePoemTextView: UITextView!
    @IBOutlet weak var quotePoemSwitch: UISwitch!
    
    let fbAuth = FireBaseController.shared
    
    var handle:AuthStateDidChangeListenerHandle?
    var userTextFromTable:UserQuotePoems?
    var isTextFromTable:Bool = false
    var email:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setDelegates()
        
        handle = fbAuth.fAuth.addStateDidChangeListener { (auth, user) in
            if self.email.isEmpty, let email = user?.email {
                self.email = email
            } else if user == nil {
                self.email = ""
            }
        }
        
        if self.isTextFromTable {
            guard let userText = self.userTextFromTable else {return}
            self.updateFields(with: userText)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fbAuth.fAuth.removeStateDidChangeListener(handle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveText(_ sender: UIButton) {
        guard let textToSave = self.quotePoemTextView.text, let titleToSave = self.titleTextField.text, !textToSave.isEmpty else {return}
        if self.isTextFromTable {
            guard let title = userTextFromTable?.title, let text = userTextFromTable?.text, let isQuote = userTextFromTable?.isQuote, let userEmail = userTextFromTable?.userEmail else {return}
            UserPoemsAndQutes().deleteUserText(title: title, text: text, isQuote: isQuote, userEmail: userEmail)
        }
        if UserPoemsAndQutes().saveUserQuoteOrPoem(title: titleToSave, text: textToSave, isQuote: self.quotePoemSwitch.isOn, userEmail: self.email) {
            let quoteOrPoem = self.quotePoemSwitch.isOn ? "poem" : "quote"
            Toast().showToast(message: NSString(format: "Your %@ was saved", quoteOrPoem) as String , font: .systemFont(ofSize: 22.0), view: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + (Toast().animationDuration - 1.0), execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func setDelegates() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let favListViewController = storyboard.instantiateViewController(withIdentifier: "FavouritesListViewController") as! FavouritesListViewController
        favListViewController.delegatUserText = self
    }
}

extension AddUserTextViewController: FavouritesListViewControllerUserTextDelegate {
    func updateFields(with userText: UserQuotePoems) {
        self.quotePoemTextView.text = userText.text
        self.titleTextField.text = userText.title
        self.quotePoemSwitch.isOn = userText.isQuote
    }
}
