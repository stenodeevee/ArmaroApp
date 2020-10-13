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
    var user: User!
    var controller: NewMatchTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    func loadData(_ user: User) {
        self.user = user
        self.usernameLabel.text = user.username
        self.avatar.layer.cornerRadius = 40
        self.avatar.clipsToBounds = true
        self.avatar.contentMode = .scaleAspectFill
        self.avatar.loadImage(user.profileImageUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
    }


}
