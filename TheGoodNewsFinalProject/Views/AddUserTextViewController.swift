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

    var handle:AuthStateDidChangeListenerHandle?
    var email:String = ""
    let fbAuth = FireBaseController.shared

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear > \(self.email) <> \(fbAuth.fAuth.currentUser)<")
        handle = fbAuth.fAuth.addStateDidChangeListener { (auth, user) in
            if self.email.isEmpty, let email = user?.email {
                self.email = email
            } else if user == nil {
                self.email = ""
            }
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
        
        if UserPoemsAndQutes().saveUserQuoteOrPoem(title: titleToSave, text: textToSave, isQuote: self.quotePoemSwitch.isOn, userEmail: self.email) {
            let quoteOrPoem = self.quotePoemSwitch.isOn ? "poem" : "quote"
            Toast().showToast(message: NSString(format: "Your %@ was saved", quoteOrPoem) as String , font: .systemFont(ofSize: 22.0), view: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + (Toast().animationDuration - 1.0), execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
}
