//
//  otherUserProfileCollectionReusableView.swift
//  Armaro
//
//  Created by ESTEFANO on 13/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit


class otherUserProfileCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "otherUserProfileInfoHeaderCollectionReusableView"
    var otherUserId: String!
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.loadImage()
        imageView.backgroundColor = .red
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        //label.text = Auth.auth().currentUser!.displayName
        //label.text = "ciao"
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        backgroundColor = .systemBackground
        clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(usernameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Api.User.getUserInforSingleEvent(uid: self.otherUserId, onSuccess: { (user) in
            self.profilePhotoImageView.loadImage(user.profileImageUrl)
            
            self.usernameLabel.text = user.username as? String
            
        })
        
        let profilePhotoSize = bounds.size.width/4
        let center = bounds.size.width/2 - profilePhotoSize/2
        
        profilePhotoImageView.frame = CGRect(x: center, y: 5, width: profilePhotoSize, height: profilePhotoSize).integral
        
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        usernameLabel.frame = CGRect(x: 5, y: 2 + profilePhotoSize, width: bounds.width - 10, height: 50 ).integral
        
        
    }

}
