//
//  AddUserTextViewController.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 17/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class AddUserTextViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var quotePoemTextView: UITextView!
    @IBOutlet weak var quotePoemSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveText(_ sender: UIButton) {
        guard let textToSave = self.quotePoemTextView.text, let titleToSave = self.titleTextField.text, !textToSave.isEmpty else {return}
        
        if UserPoemsAndQutes().saveUserQuoteOrPoem(title: titleToSave, text: textToSave, isQuote: self.quotePoemSwitch.isOn, userEmail: User().email) {
            let quoteOrPoem = self.quotePoemSwitch.isOn ? "poem" : "quote"
            Toast().showToast(message: NSString(format: "Your %@ was saved", quoteOrPoem) as String , font: .systemFont(ofSize: 22.0), view: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + (Toast().animationDuration - 1.0), execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
}
