//
//  Post.swift
//  Armaro
//
//  Created by ESTEFANO on 21/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class Post: NSObject {

    
    var username: String!
    var brand: String!
    var pathToImage: String!
    var userID: String!
    var postID: String!
    var userImage_url: String!
    var caption: String!
    var size: String!
    var typeOfClothing: String!
    var gender: String!



    static func transformPost(dict: [String: Any]) -> Post? {
        guard let username = dict["author"] as? String,
            let brand = dict["brand"] as? String,
            let userImage_url = dict["author_profile_url"] as? String,
            let pathToImage = dict["image_url"] as? String,
            let userID = dict["userID"] as? String,
            let postID = dict["postID"] as? String,
            let caption = dict["description"] as? String,
            let size = dict["size"] as? String,
            let typeOfClothing = dict["type"] as? String,
            let gender = dict["gender"] as? String else {
                return nil
        }
        let userPost = Post()
        userPost.brand = brand
        userPost.pathToImage = pathToImage
        userPost.username = username
        userPost.userImage_url = userImage_url
        userPost.postID = postID
        userPost.userID = userID
        userPost.caption = caption
        userPost.size = size
        userPost.typeOfClothing = typeOfClothing
        userPost.gender = gender
              
        return userPost
        
    }

}
