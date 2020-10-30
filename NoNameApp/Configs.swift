//
//  Configs.swift
//  Armaro
//
//  Created by ESTEFANO on 26/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import Foundation

let serverKey = "AAAAzAP0Rx8:APA91bEs4mD3s5mMVPOmeVMY7S7UBwTqTLXi1yA6mpyDPcirt23cU7liRrR2yHa8Lfn9wHTaCM0mynZ0FEDVrKSbRYU12ZT3UOiwjmoBek6q4QDqiQFKxYwgS6lKVcakVTgy68Z5PzDV"
let fcmUrl = "https://fcm.googleapis.com/fcm/send"

func sendRequestNotification(isMatch: Bool = false, fromUser: Post, toUser: Post, message: String, convId: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to" : "/topics/\(toUser.postID)",
                                        "notification" : ["title": (isMatch==false) ? fromUser.username : "New Trade",
                                                          "body": message,
                                                          "sound" : "default",
                                                          "badge": badge,
                                                          "customData" : ["userId": fromUser.userID,
                                                                          "conversationId" : convId,
                                                                          "toPostId": toUser.postID,
                                                                          "username": fromUser.username,
                                                                          "fromPostId": fromUser.postID,
                                                                          "profileImageUrl": fromUser.userImage_url,
                                                                          "toProfileImageUrl": toUser.userImage_url,
                                                                          "toUsername": toUser.username
                                                                            ]
        ]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(response!)")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
        }.resume()}
