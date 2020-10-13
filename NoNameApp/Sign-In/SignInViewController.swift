//
//  SignInViewController.swift
//  NoNameApp
//
//  Created by ESTEFANO on 11/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import ProgressHUD


class SignInViewController: UIViewController {

    
    @IBAction func gobackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        setupSignInLabel()
        setupSignInButton()
        setupEmailField()
        setupPasswordField()
        setupSignUpButton()
        setupForgotPasswordButton()

    }
    
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.signIn( onSuccess: {
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()

        }) {(errorMessage) in
            ProgressHUD.showError(errorMessage)}
    }
    
    
}
