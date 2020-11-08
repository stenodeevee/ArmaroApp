//
//  UserApi.swift
//  Armaro
//
//  Created by ESTEFANO on 14/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import ProgressHUD
import FirebaseStorage
import FirebaseMessaging


class UserApi {
       

    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }
    
            
    
    func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    

    
    // MARK: Sign In
    func signIn(email: String, passoword: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: passoword, completion: { (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            print(authData?.user.uid)
            onSuccess()
        })
    }
    
    // MARK: Sign Up
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (AuthDataResult, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            if let authData = AuthDataResult {
                print(authData.user.email)
                var dict: Dictionary<String, Any> = [
                    "uid": authData.user.uid,
                    "email": authData.user.email,
                    "username": username,
                    "profileImageUrl":"",
                    "gender":"M",
                    "shoesize":"",
                    "topsize":"M",
                    "bottomsize":"44",
                    "status":"Welcome to Armaro"
                ]
                
                guard let imageSelected = image else {
                    ProgressHUD.showError("Please choose your profile image")
                    return
                }
                
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
                    return
                }
                

                
                let storageProfile = Ref().storageSpecificProfile(uid: authData.user.uid)
               
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                
                StorageService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: metadata, storageProfileRef: storageProfile , dict: dict, onSuccess: {
                    onSuccess()
                }, onError: {(errorMessage) in
                    onError(errorMessage)
                    
                })

            }
                      
            
        }
    }
    
    // MARK: Password Reset
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
            
        }
        
    }
    
    
    func updateProfile(index: String, value: String) {
        var ref = Ref().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).updateChildValues([index: value])
        
    }
    
    
    
    
    func logOut() {
        let uid = Api.User.currentUserId
        do {
            try Auth.auth().signOut()
            Messaging.messaging().unsubscribe(fromTopic: uid)
            
        } catch {
            
            ProgressHUD.showError(error.localizedDescription)
            return
        }
        (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
        
    }
    
    
}

typealias UserCompletion = (User) -> Void

