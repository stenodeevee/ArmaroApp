//
//  AppDelegate.swift
//  NoNameApp
//
//  Created by ESTEFANO on 10/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKEY = "gcm.message_id"
    static var isToken: String? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configureInitialViewController()
        
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.sound, .badge, .alert]
            
            current.requestAuthorization(options: options) {(granted, error) in
                if error != nil {
                    
                } else {
                    Messaging.messaging().delegate = self
                    current.delegate = self
                    
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            let types: UIUserNotificationType = [.sound, .badge, .alert]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        
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
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFirebase()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let messageId = userInfo[gcmMessageIDKEY] {
                    print("messageId: \(messageId)")
                }
                
        print(userInfo)
    }
    
    func connectToFirebase() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        return nil
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKEY] {
            print("messageID: \(messageID)")
        }
        connectToFirebase()
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let dictString = userInfo["gcm.notification.customData"] as? String {
           print("dictString \(dictString)")
    
            if let dict = convertToDictionary(text: dictString) {
                if let id = dict["conversationId"] as? String,
                   let currentPostId = dict["toPostId"] as? String,
                   let otherPostId = dict["fromPostId"] as? String,
                   let otherUserImageUrl = dict["profileImageUrl"] as? String,
                   let othername = dict["username"] as? String,
                   let currentUserImageUrl = dict["toProfileImageUrl"] as? String,
                   let currentname = dict["toUsername"] as? String {
                    
                    if id != "" {
                        let vc = ChatViewController(with: id, currentPostId: currentPostId, otherPostId: otherPostId)
                        vc.isNewConversation = false
                        vc.title = othername
                        vc.otherPhoto = otherUserImageUrl
                    
                        vc.senderName = currentname
                        vc.senderPhoto = currentUserImageUrl
                    
                        vc.navigationItem.largeTitleDisplayMode = .never
                        guard let currentVC = UIApplication.topViewController() else {
                            return
                        }
                    
                        currentVC.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let newMatchVC = storyboard.instantiateViewController(withIdentifier: "NewMatchTableViewController") as! NewMatchTableViewController
                        guard let currentVC = UIApplication.topViewController() else {
                            return
                        }
                    
                        currentVC.navigationController?.pushViewController(newMatchVC, animated: true)
                    }
                }
                
            }
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = AppDelegate.isToken else {
            return
        }
        print("token: \(token)")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let message = userInfo[gcmMessageIDKEY] {
            print("Message: \(message)")
        }
        print(userInfo)
        completionHandler([.sound, .badge, .alert])
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        guard let token = AppDelegate.isToken else {
            return
        }
        print("Token: \(token)")
        connectToFirebase()
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("remoteMessage: \(remoteMessage.appData)")
    }
    
}

