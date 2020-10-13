//
//  AppDelegate.swift
//  NoNameApp
//
//  Created by ESTEFANO on 10/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configureInitialViewController()
        return true
    }
    
    func configureInitialViewController() {
        var initialVC: UIViewController
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        
        if Auth.auth().currentUser != nil {
            initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_TABBAR)
        }
        else {
            initialVC =
                storyboard.instantiateViewController(withIdentifier: IDENTIFIER_WELCOME)
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    
    func toGenderVC() {
        var initialVC: UIViewController
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        if Auth.auth().currentUser != nil {
            initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_GENDER)
        }
        else {
            initialVC =
                storyboard.instantiateViewController(withIdentifier: IDENTIFIER_WELCOME)
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    

    



}

