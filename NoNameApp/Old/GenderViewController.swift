//
//  GenderViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 18/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class GenderViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var labelOverGenderChoice: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsGenderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        setupGenderTitleLabel()
        setupContinueButton()
        setupChangeSettingsLabel()
        setupLabelOverGChoice()
    }
    
    let user = Auth.auth().currentUser;
    
    
    
    var sex = ""
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sex = "M"
        }
        else if sender.selectedSegmentIndex == 1 {
            sex = "F"
        }
        
        Api.User.updateProfile(index: "gender", value: sex)
        
        
    }

}
