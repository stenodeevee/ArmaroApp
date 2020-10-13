//
//  FeedPostGeneralTableViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 25/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

///Brand and sizes
class FeedPostGeneralTableViewCell: UITableViewCell {

    static let identifier = "FeedPostGeneralTableViewCell"

    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let brandLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(brandLabel)
        contentView.addSubview(sizeLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with model: Post) {
        brandLabel.text = model.brand.uppercased()
        sizeLabel.text = "SIZE: " + model.size
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.bounds.height - 4
        let length = contentView.bounds.width - (size*2) - 15
        brandLabel.frame = CGRect(x: 4, y: 2, width: length, height: size)
        
        sizeLabel.frame = CGRect(x : contentView.bounds.width - 80, y : 2, width: length, height: size)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sizeLabel.text = nil
        brandLabel.text = nil
    }
}
