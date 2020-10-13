//
//  SignUpViewController.swift
//  NoNameApp
//
//  Created by ESTEFANO on 11/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD
import CoreLocation
import GeoFire

class SignUpViewController: UIViewController {


    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet var avatarContainer: UIView!
    
    @IBAction func dismiss(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var fullNameContainer: UIView!
    
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordContainer: UIView!
    @IBOutlet weak var passwordText: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var image: UIImage? = nil
    let manager = CLLocationManager()
    var userLat = ""
    var userLong = ""
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        setupUI()
        
    }
    
    func setupUI() {
        
        setupTitleLabel()
        setupAvatar()
        setupFullNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
        setupSignInButton()
    }
    
    
    
    func validateFields() {
        guard let username = self.fullNameText.text, !username.isEmpty else {
            ProgressHUD.showError("Please enter a valid username")
            return
        }
        guard let email = self.emailText.text, !email.isEmpty else {
            ProgressHUD.showError("Please enter a valid email")
            return
        }
        guard let password = self.passwordText.text, !password.isEmpty else {
            ProgressHUD.showError("Please enter a valid password")
            return
        }

    }
    


    @IBAction func SignUpButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        
        
        if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
           let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
            print("latitude is", userLat)
            print("longitude is", userLong)
            self.userLat = userLat
            self.userLong = userLong
        }
        
        
        
        self.signUp( onSuccess: {
            if !self.userLat.isEmpty && !self.userLong.isEmpty {
                let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(self.userLat)!), longitude: CLLocationDegrees(Double(self.userLong)!))
                //send location to firebase
                self.geoFireRef = Ref().databaseGeo
                self.geoFire = GeoFire(firebaseRef: self.geoFireRef)
                guard let currentUserId = Auth.auth().currentUser?.uid else {
                    return
                }
                
                self.geoFire.setLocation(location, forKey: currentUserId)
                
            }
            //(UIApplication.shared.delegate as! AppDelegate).toGenderVC()
            
            
           (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
            
        }) {(errorMessage) in
            ProgressHUD.showError(errorMessage)
        }

    }
 
    
    
    
}
