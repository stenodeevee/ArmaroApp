//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Armaro
//
//  Created by ESTEFANO on 24/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol ProfileInfoHeaderCollectionReusableViewDelegate: AnyObject  {
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView)
}

final class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileInfoHeaderCollectionReusableView"
    public weak var delegate: ProfileInfoHeaderCollectionReusableViewDelegate?
    
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.loadImage(Auth.auth().currentUser!.photoURL!.absoluteString)       
        
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.setTitle("Edit your profile", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = Auth.auth().currentUser!.displayName
        label.numberOfLines = 1
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addButtonActions()
        backgroundColor = .systemBackground
        clipsToBounds = true
        
    }
    
    private func addSubviews() {
        addSubview(profilePhotoImageView)
        addSubview(editProfileButton)
        addSubview(usernameLabel)
    }
    
    private func addButtonActions() {
        editProfileButton.addTarget(self, action: #selector(didTapEditProfileButton),
                                    for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let profilePhotoSize = bounds.size.width/4
        profilePhotoImageView.frame = CGRect(x: 5, y: 5, width: profilePhotoSize, height: profilePhotoSize).integral
        
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoSize/2.0
        
        let buttonHeight = profilePhotoSize*2/3
        let buttonWidth = bounds.size.width - profilePhotoSize - 20
        
        editProfileButton.frame = CGRect(x: 10 + profilePhotoSize, y: 5 + profilePhotoSize/6, width: buttonWidth, height: buttonHeight).integral
        
        usernameLabel.frame = CGRect(x: 5, y: 2 + profilePhotoSize, width: bounds.width - 10, height: 50 ).integral
        
        
    }
    
    // MARK - ACTIONS
    
    @objc private func didTapEditProfileButton() {
        delegate?.profileHeaderDidTapEditProfileButton(self)
    }
    

    
}
