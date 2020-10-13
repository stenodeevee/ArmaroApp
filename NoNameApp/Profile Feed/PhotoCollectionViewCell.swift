//
//  PhotoCollectionViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 24/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

import SDWebImage
class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        
        
    }
    
    required init?(coder:NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Post) {
        let url = model.pathToImage
        photoImageView.loadImage(url)
        
    }
    
    public func configure(debug imageName: String) {
         photoImageView.image = UIImage(named: imageName)
        
    }
}
