//
//  ItemsAroundCollectionViewCell.swift
//  Armaro
//
//  Created by ESTEFANO on 07/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class ItemsAroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    
    
    var post: Post!
    var controller: ItemsAroundViewController!
        
        
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadData(_ post: Post, currentLocation: CLLocation?) {
        self.post = post
        self.brandLabel.text = post.brand
        self.avatar.clipsToBounds = true
        self.avatar.contentMode = .scaleAspectFill
        self.avatar.loadImage(post.pathToImage)
        
        
        guard let _ = currentLocation else {
            return
        }
        
        let refUser = Ref().databaseSpecificUser(uid: post.userID)
        refUser.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            if let user = snapshot.value as? [String:Any] {
                
                guard let latitude = user["current_latitude"] as? String,
                      let longitude = user["current_longitude"] as? String else {
                    print("we don't know his position")
                    self?.distanceLabel.text = ""
                    return
                }
                
                let userLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                let distance: CLLocationDistance = userLocation.distance(from: currentLocation!)/1000
                
                self?.distanceLabel.text = String(format: "%.2f km", distance)
            }
        })
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
    }
}
