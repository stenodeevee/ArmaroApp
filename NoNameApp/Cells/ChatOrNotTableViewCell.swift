//
//  ChatOrNotTableViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 14/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

protocol ChatOrNotTableViewCellDelegate: AnyObject {
    func chatDidTapButton(_ cell: ChatOrNotTableViewCell)
    func refuseDidTapButton(_ cell: ChatOrNotTableViewCell)
}

class ChatOrNotTableViewCell: UITableViewCell {
    
    var otherPostId: String!
    var yourPostId: String!
    var targetUserID: String!
    
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    public weak var delegate: ChatOrNotTableViewCellDelegate?

    @IBAction func chatButtonDidTap(_ sender: Any) {
        delegate?.chatDidTapButton(self)
    }
        
    @IBAction func refuseButtonDidTap(_ sender: Any) {
        delegate?.refuseDidTapButton(self)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        chatButton.layer.cornerRadius = 5
        refuseButton.layer.cornerRadius = 5
        // Configure the view for the selected state
    }

}
