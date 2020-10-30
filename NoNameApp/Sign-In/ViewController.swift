//
//  ViewController.swift
//  NoNameApp
//
//  Created by ESTEFANO on 10/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

/// Welcome view controller, first view that is opened by a new user, its UI is designed in the ViewController + UI 
class ViewController: UIViewController {
    
    // this controller simply lets decide whether you want to sign in or sign up
    // sends to signUpViewController or SigninViewController

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var signInGoogle: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    

    
    
    func setupUI() {
        
        setupHeaderTitle()
        setupOrLabel()
        setupTermsOfService()
        setupGoogleButton()
        setupCreateAccountButton()
        
    }

}



