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
    
    private let currentItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGreen.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let otherItemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let forLabel: UILabel = {
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
        contentView.addSubview(currentItemImageView)
        contentView.addSubview(otherItemImageView)
        contentView.addSubview(forLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
 
        currentItemImageView.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
        forLabel.frame = CGRect(x: 100, y: 10, width: 30, height: (contentView.bounds.height-20))
        otherItemImageView.frame = CGRect(x: 130, y: 10, width: 80, height: 80)
        
        userMessageLabel.frame = CGRect(x: 220, y: 10, width: contentView.bounds.width - 230, height: (contentView.bounds.height-20))
    }
    
    public func configure(with model: Conversation) {
        self.userMessageLabel.text = model.latestMessage.text
        self.forLabel.text = "for"
        
        Api.Post.getPostInforSingleEvent(postID: model.otherPostId, onSuccess: {[weak self] (post) in
            let photo = post.pathToImage
            DispatchQueue.main.async {
                self?.otherItemImageView.loadImage(photo)
            }
        })
        
        
        Api.Post.getPostInforSingleEvent(postID: model.currentPostId, onSuccess: {[weak self] (post) in
            let photo = post.pathToImage
            DispatchQueue.main.async {
                self?.currentItemImageView.loadImage(photo)
            }
        })
        
    }

}
