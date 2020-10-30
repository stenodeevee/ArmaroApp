//
//  SignUpViewController+UI.swift
//  NoNameApp
//
//  Created by ESTEFANO on 11/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import ProgressHUD
import CoreLocation

extension SignUpViewController {
    
    
    func configureLocationManager() {
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    func setupTitleLabel() {
        let title = "Sign Up"
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.label ])
        
        titleLabel.attributedText = attributedText
        
    }
    
    
    func setupAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)

    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func setupFullNameTextField() {
        fullNameContainer.layer.borderWidth = 1
        fullNameContainer.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        
        fullNameContainer.layer.cornerRadius = 3
        fullNameContainer.clipsToBounds = true
        
        fullNameText.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        fullNameText.attributedPlaceholder = placeholderAttr
    }
    
    
    func setupEmailTextField() {

        emailContainer.layer.borderWidth = 1
        emailContainer.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        
        emailContainer.layer.cornerRadius = 3
        emailContainer.clipsToBounds = true
        
        emailText.borderStyle = .none
        let placeholderAttr = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        emailText.attributedPlaceholder = placeholderAttr
    }
    
    
    func setupPasswordTextField() {
        passwordContainer.layer.borderWidth = 1
        passwordContainer.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        
        passwordContainer.layer.cornerRadius = 3
        passwordContainer.clipsToBounds = true
        
        passwordText.borderStyle = .none
        
        let placeholderAttr = NSAttributedString(string: "Password (8 or + characters)", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        passwordText.attributedPlaceholder = placeholderAttr    }
    
    
    func setupSignUpButton() {
        signUpButton.layer.borderColor = UIColor.systemGreen.cgColor
        signUpButton.layer.borderWidth = 1.0
        signUpButton.setTitle("Sign Up", for: UIControl.State.normal)
        signUpButton.setTitleColor(.white, for: UIControl.State.normal)
        signUpButton.backgroundColor = UIColor.systemGreen
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.layer.cornerRadius = 5
        signUpButton.clipsToBounds = true
    }
    
    
    func setupSignInButton() {

        let attributedSINText = NSMutableAttributedString(string: "Already have an account?" , attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel ])
         
        
        let attributedBoldSINText = NSMutableAttributedString(string: " Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor: UIColor.tertiaryLabel])
         
        attributedSINText.append(attributedBoldSINText)
        
        signInButton.setAttributedTitle(attributedSINText, for: UIControl.State.normal)
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) ->
        Void) {
        ProgressHUD.show("Loading...")
        //send to firebase
           
        
        Api.User.signUp(withUsername: self.fullNameText.text!, email: self.emailText.text!, password: self.passwordText.text!, image: self.image, onSuccess: {
            ProgressHUD.dismiss()
            onSuccess()
        }) {(errorMessage) in
           onError(errorMessage)
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            avatar.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            avatar.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showError("\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let updatedLocation: CLLocation = locations.first!
        let newCoordinate: CLLocationCoordinate2D = updatedLocation.coordinate
        print(newCoordinate.latitude)
        print(newCoordinate.longitude)
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set("\(newCoordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCoordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
    }
}

