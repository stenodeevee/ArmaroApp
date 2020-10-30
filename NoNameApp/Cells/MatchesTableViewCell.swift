//
//  MatchesTableViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 09/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var otherPost: UIImageView!

    var controller: NewMatchTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    func loadData(_ currentUserPostID: String, otherUserPostID: String) {

        self.avatar.layer.cornerRadius = 40
        self.avatar.layer.borderWidth = 2
        self.avatar.layer.borderColor = UIColor.systemGreen.cgColor
        self.avatar.clipsToBounds = true
        self.avatar.contentMode = .scaleAspectFill
        Api.Post.getPostInforSingleEvent(postID: currentUserPostID, onSuccess: {(post) in
            guard let postImage = post.pathToImage else {
                print("no image")
                return
            }
            self.avatar.loadImage(postImage)
            
        })
        
        self.otherPost.layer.cornerRadius = 40
        self.otherPost.layer.borderWidth = 2
        self.otherPost.layer.borderColor = UIColor.systemRed.cgColor
        self.otherPost.clipsToBounds = true
        self.otherPost.contentMode = .scaleAspectFill
        Api.Post.getPostInforSingleEvent(postID: otherUserPostID, onSuccess: {(post) in
            guard let postImage = post.pathToImage else {
                print("no image")
                return
            }
            self.otherPost.loadImage(postImage)
        })
   
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
    }


}
