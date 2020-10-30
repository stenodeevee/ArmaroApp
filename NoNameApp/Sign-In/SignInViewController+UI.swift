//
//  SignInViewController+UI.swift
//  NoNameApp
//
//  Created by ESTEFANO on 11/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import ProgressHUD

extension SignInViewController {
    
    func setupSignInLabel() {
        let title = "Sign In"
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.label ])
        
        signInLabel.attributedText = attributedText
        
    }
    
    
    func setupSignInButton() {
        signInButton.layer.borderColor = UIColor.systemGreen.cgColor
        signInButton.layer.borderWidth = 1.0
        signInButton.setTitle("Sign In", for: UIControl.State.normal)
        signInButton.setTitleColor(.white, for: UIControl.State.normal)
        signInButton.backgroundColor = UIColor.systemGreen
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        
    }
    
    
    func setupEmailField() {
        emailContainer.layer.borderWidth = 1
        emailContainer.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
    
        emailContainer.layer.cornerRadius = 3
        emailContainer.clipsToBounds = true
    
        emailTextField.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
    
        emailTextField.attributedPlaceholder = placeholderAttr    }
    
    func setupPasswordField() {
        passwordContainer.layer.borderWidth = 1
        passwordContainer.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        
        passwordContainer.layer.cornerRadius = 3
        passwordContainer.clipsToBounds = true
        
        passwordTextField.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        passwordTextField.attributedPlaceholder = placeholderAttr
    }
    
    func setupSignUpButton() {
        let attributedSINText = NSMutableAttributedString(string: "Don't have an account?" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.tertiaryLabel ])
         
        
        let attributedBoldSINText = NSMutableAttributedString(string: " Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
         
        attributedSINText.append(attributedBoldSINText)
        
        signUpButton.setAttributedTitle(attributedSINText, for: UIControl.State.normal)
    }
    
    func setupForgotPasswordButton() {
        let attributedPSText = NSMutableAttributedString(string: "Forgot Password?" , attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.tertiaryLabel ])
         
        
               
        forgotPasswordButton.setAttributedTitle(attributedPSText, for: UIControl.State.normal)
        
    }
    
    func validateFields() {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showError("The email you inserted is not correct")
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showError("The password you inserted is not correct")
            return    }
        
    }
    
    
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) ->
        Void) {
        ProgressHUD.show("Loading...")
        Api.User.signIn(email: self.emailTextField.text!, passoword: self.passwordTextField.text!, onSuccess: {
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }

    }

}
