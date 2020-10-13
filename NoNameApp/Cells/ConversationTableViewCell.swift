//
//  ConversationTableViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 05/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ConversationTableViewCell: UITableViewCell {
    
    
    static let identifier = "ConversationTableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(userMessageLabel)    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
 
        userImageView.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        usernameLabel.frame = CGRect(x: 120, y: 10, width: contentView.bounds.width - 20 - userImageView.bounds.width, height: (contentView.bounds.height-20)/2)
        userMessageLabel.frame = CGRect(x: 120, y: 20+(contentView.bounds.height-20)/2, width: contentView.bounds.width - 20 - userImageView.bounds.width, height: (contentView.bounds.height-20)/2)
    }
    
    public func configure(with model: Conversation) {
        self.userMessageLabel.text = model.latestMessage.text
        self.usernameLabel.text = model.name
        
        
        Ref().storageProfile.child(model.otherUserId).downloadURL(completion: {(url, error) in
            let photoUrl = url?.absoluteString
            
            DispatchQueue.main.async {
                self.userImageView.loadImage(photoUrl!)
            }
        })
    }

}
