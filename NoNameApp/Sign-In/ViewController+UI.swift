//
//  ViewController+UI.swift
//  NoNameApp
//
//  Created by ESTEFANO on 11/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

extension ViewController{
    
    func setupHeaderTitle() {
        let title = "Welcome to ARMARO"
        let subtitle = "\nSign-in to your account"
    
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.label ])
        let attributedSubTitle = NSMutableAttributedString(string: subtitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel])
    
        attributedText.append(attributedSubTitle)
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
    }
    
    func setupOrLabel() {
        orLabel.text = "Or"
        orLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orLabel.textColor = UIColor.secondaryLabel
        orLabel.textAlignment = .center
        
        
    }

    func setupTermsOfService() {
        let attributedTermsText = NSMutableAttributedString(string: "By clicking ''Create a new account'' you agree to our " , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.tertiaryLabel])
         
        
        let attributedSubTermsText = NSMutableAttributedString(string: "Terms of Service.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
         
         attributedTermsText.append(attributedSubTermsText)
         
         termsOfServiceLabel.attributedText = attributedTermsText
         termsOfServiceLabel.numberOfLines = 0
    }
    
    
    func setupGoogleButton() {
        signInGoogle.setTitle("Log in to your Account", for: UIControl.State.normal)
        signInGoogle.setTitleColor(UIColor.white, for: .normal)
        signInGoogle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signInGoogle.backgroundColor = UIColor.systemGreen
        signInGoogle.layer.cornerRadius = 5
        signInGoogle.clipsToBounds = true
        
    }
    
    func setupCreateAccountButton() {
        createNewAccountButton.layer.borderColor = UIColor.label.cgColor
        createNewAccountButton.layer.borderWidth = 1.0
        createNewAccountButton.setTitle("Create a New Account", for: UIControl.State.normal)
        createNewAccountButton.setTitleColor(.black, for: .normal)
        createNewAccountButton.backgroundColor = UIColor.white
        createNewAccountButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        createNewAccountButton.layer.cornerRadius = 5
        createNewAccountButton.clipsToBounds = true
    }
    
}
