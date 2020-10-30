//
//  PostApi.swift
//  Armaro
//
//  Created by ESTEFANO on 14/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import Foundation

class PostApi {
    func getPostInforSingleEvent(postID: String, onSuccess: @escaping(PostCompletion)) {
        let ref = Ref().databaseRoot.child("items/\(postID)")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let post = Post.transformPost(dict: dict) {
                    onSuccess(post)
                }
            }
        }
    }
    
    
}

typealias PostCompletion = (Post) -> Void
