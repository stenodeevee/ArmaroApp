//
//  User.swift
//  Armaro
//
//  Created by ESTEFANO on 09/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import Foundation
import UIKit

class User {
    var uid: String
    var username: String
    var email: String
    var profileImageUrl: String
    var status: String
    var gender = ""
    var shoesize = ""
    var bottomsize = ""
    var topsize = ""
    var latitude = ""
    var longitude = ""
    
    init(uid: String, username: String, email: String, profileImageUrl: String, status: String) {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.status = status
    }
    
    static func transformUser(dict: [String: Any]) -> User? {
        guard let email = dict["email"] as? String,
            let username = dict["username"] as? String,
            let profileImageUrl = dict["profileImageUrl"] as? String,
            let status = dict["status"] as? String,
            let uid = dict["uid"] as? String else {
                return nil
        }
        let user = User(uid: uid, username: username, email: email, profileImageUrl: profileImageUrl, status: status)
        if let gender = dict["gender"] as? String {
                   user.gender = gender
               }
        if let latitude = dict["current_latitude"] as? String {
                   user.latitude = latitude
               }
        if let longitude = dict["current_longitude"] as? String {
                   user.longitude = longitude
               }
        if let longitude = dict["current_longitude"] as? String {
            user.longitude = longitude
        }
               
        return user
        
    }
    
}




