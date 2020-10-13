//
//  Ref.swift
//  Armaro
//
//  Created by ESTEFANO on 14/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import Foundation
import Firebase


let REF_USER = "users"
let URL_STORAGE_ROOT = "gs://armaro-f5569.appspot.com"
let STORAGE_PROFILE = "profile"
let PROFILE_IMAGE_URL = "profileImageUrl"

let IDENTIFIER_TABBAR = "TabBarVC"
let IDENTIFIER_WELCOME = "WelcomeVC"
let IDENTIFIER_GENDER = "GenderVC"
let IDENTIFIER_SIZES = "SizesVC"
let IDENTIFIER_PROFILE = "ProfileTableViewCell"
let IDENTIFIER_ITEMS_AROUND = "ItemsAroundViewController"

let SHOE_SIZES = ["36","37","38","39","40","41","42","43","44","45","46"]
let SHIRT_SIZES = ["XXS","XS","S","M","L","XL","XXL"]
let PANTS_SIZES = ["38","40","42","44","46","48","50","52","54"]

let TYPE_OF_CLOTHING = ["tops","bottoms","shoes"]
var chosenType = ""
var chosenSize = ""

class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid:String) -> DatabaseReference {
        return databaseUsers.child(uid)
  
    }
    
    var databaseGeo: DatabaseReference {
        return databaseRoot.child("Geolocs")
    }
    
    var databaseAction: DatabaseReference {
        return databaseRoot.child("actions")
    }
    
    func databaseActionForUser(uid:String) -> DatabaseReference {
        return databaseAction.child(uid)
    }
    
    func databaseIsOnline(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid).child("isOnline")
    }
    
    // Storage Ref
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
