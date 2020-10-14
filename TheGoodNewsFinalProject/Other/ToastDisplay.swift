//
//  ToastDisplay.swift
//  TheGoodNewsFinalProject
//
//  Created by The App Experts on 14/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class Toast {
    //function  showToast copied from
    //https://stackoverflow.com/questions/31540375/how-to-toast-message-in-swift
    func showToast(message : String, font: UIFont, view: UIView) {
        
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 125, y: view.frame.size.height/2-90, width: 250, height: 50))
        toastLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
