//
//  YourClothesTableViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 14/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class YourClothesTableViewCell: UITableViewCell {

    @IBOutlet weak var yourClothesImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(postID: String) {
        Api.Post.getPostInforSingleEvent(postID: postID, onSuccess: { [weak self] (post) in
            guard let postImage = post.pathToImage else {
                print("couldn't retrieve post")
                return
            }
            
            self?.yourClothesImageView.loadImage(postImage)
    
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
