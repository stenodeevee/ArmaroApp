//
//  FeedPostActionsTableViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 25/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

protocol FeedPostActionsTableViewCellDelegate: AnyObject {
    func didTapLikeButton()
    func didTapNopeButton()
    func didTapInfoButton(cell: FeedPostActionsTableViewCell)
        
}
/// Like and dislike(?)
class FeedPostActionsTableViewCell: UITableViewCell {

    static let identifier = "FeedPostActionsTableViewCell"
    weak var delegate: FeedPostActionsTableViewCellDelegate?
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_circle"), for: .normal)
        return button
    }()
    
    private let nopeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nope_circle"), for: .normal)
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        let image = UIImage(systemName: "paperplane", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(likeButton)
        contentView.addSubview(nopeButton)
        contentView.addSubview(infoButton)
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        nopeButton.addTarget(self, action: #selector(didTapNopeButton), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
        
        
    }
    
    @objc private func didTapLikeButton() {
        delegate?.didTapLikeButton()
    }
    
    @objc private func didTapNopeButton() {
        delegate?.didTapNopeButton()
    }
    
    @objc private func didTapInfoButton() {
        delegate?.didTapInfoButton(cell: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure() {
        // configure the cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //nope, info, like
        
        let buttonSize = contentView.bounds.height - 10
        let start = contentView.bounds.width / 2 - buttonSize*3/2 - 20
        
        let buttons = [nopeButton, infoButton, likeButton]
        for x in 0..<buttons.count {
            let button = buttons[x]
            button.frame = CGRect(x: start + CGFloat(x)*buttonSize + 20*CGFloat(x), y: 5, width: buttonSize, height: buttonSize)
        }
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
}
