//
//  ForgotPasswordViewController+UI.swift
//  NoNameApp
//
//  Created by ESTEFANO on 11/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

extension ForgotPasswordViewController  {
    
    func setupRetrievePassword() {
        
        retrievePsswordButton.layer.borderColor = UIColor.label.cgColor
        retrievePsswordButton.layer.borderWidth = 1.0
        retrievePsswordButton.setTitle("Reset Password", for: UIControl.State.normal)
        retrievePsswordButton.setTitleColor(.white, for: UIControl.State.normal)
        retrievePsswordButton.backgroundColor = UIColor.black
        retrievePsswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        retrievePsswordButton.layer.cornerRadius = 5
        retrievePsswordButton.clipsToBounds = true
        
    }
    func setupEmailTextfield() {
        emailContainer.layer.borderWidth = 1
        emailContainer.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        
        emailContainer.layer.cornerRadius = 3
        emailContainer.clipsToBounds = true
        
        emailText.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        emailText.attributedPlaceholder = placeholderAttr
    }
    
    
    
}
