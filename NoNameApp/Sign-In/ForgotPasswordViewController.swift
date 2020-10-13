//
//  ForgotPasswordViewController.swift
//  NoNameApp
//
//  Created by ESTEFANO on 11/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import ProgressHUD

class ForgotPasswordViewController: UIViewController {

    
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var retrievePsswordButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()

    }
    func setupUI() {
        setupRetrievePassword()
        setupEmailTextfield()
    }

    
    @IBAction func resetPasswordDidTapped(_ sender: Any) {
        guard let email = emailText.text, email != "" else {
            ProgressHUD.showError("Please enter email address for password reset")
            return
        }
        
        Api.User.resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess("We have reset your password! Check your mail inbox and follow the instructions.")
            self.navigationController?.popViewController(animated: true)
        }) {(errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
}
