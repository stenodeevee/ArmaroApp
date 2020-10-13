//
//  PostHeaderTableViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 25/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

protocol FeedPostHeaderTableViewCellDelegate: AnyObject {
    func didTapMoreButton()
   
    
    
    
}

/// Username and profile picture
class FeedPostHeaderTableViewCell: UITableViewCell {

    static let identifier = "FeedPostHeaderTableViewCell"
    weak var delegate : FeedPostHeaderTableViewCellDelegate?
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        
        button.tintColor = .label
        button.setImage(UIImage(systemName:"ellipsis"), for: .normal)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePhotoImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(self,
                             action: #selector(didTapButton),
                             for: .touchUpInside)
        
    }
    
    @objc private func didTapButton() {
        delegate?.didTapMoreButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with model: Post) {
        // configure the cell
        usernameLabel.text = model.username
        profilePhotoImageView.loadImage(model.userImage_url)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = contentView.bounds.height - 4
        profilePhotoImageView.frame  = CGRect(x: 2, y: 2, width: size, height: size)
        profilePhotoImageView.layer.cornerRadius = size/2
        
        moreButton.frame = CGRect(x: contentView.bounds.width-size, y: 2, width: size, height: size)
        usernameLabel.frame = CGRect(x: 12 + size, y: 2, width: contentView.bounds.width - (size*2) - 15, height: size)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text =  nil
        profilePhotoImageView.image = nil
    }
}
