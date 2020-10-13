//
//  Card.swift
//  Armaro
//
//  Created by ESTEFANO on 09/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import CoreLocation

class Card: UIView {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var controller: RadarViewController!
    
    var post: Post! {
        didSet {
            
            photo.loadImage(post.pathToImage)
            let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            photo.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
            photo.layer.cornerRadius = 10
            photo.clipsToBounds = true
            
            infoButton.tintColor = .label
            
            let attributedBrandLabelText = NSMutableAttributedString(string: "\(post.brand!.uppercased()), " ,
                                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),
                                                                              NSAttributedString.Key.foregroundColor : UIColor.white])
            
            let attributedSizeLabelText = NSMutableAttributedString(string: "\(post.size!.uppercased())" ,
                                                                 attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
                                                                              NSAttributedString.Key.foregroundColor : UIColor.white])
            attributedBrandLabelText.append(attributedSizeLabelText)
            
            brandLabel.attributedText = attributedBrandLabelText
            
            
            if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String, let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
                let currentLocation: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
                
                let refUser = Ref().databaseSpecificUser(uid: post.userID)
                refUser.observeSingleEvent(of: .value, with: { [weak self] snapshot in
                    if let user = snapshot.value as? [String:Any] {
                        
                        guard let latitude = user["current_latitude"] as? String,
                              let longitude = user["current_longitude"] as? String else {
                            print("we don't know his position")
                            self?.locationLabel.text = ""
                            return
                        }
                        
                        let userLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
                        let distance: CLLocationDistance = userLocation.distance(from: currentLocation)/1000
                        
                        self?.locationLabel.text = String(format: "%.2f km", distance)
                        //self?.locationLabel.text =
                        self?.locationLabel.textColor = .white
                    }
                })
            }      
        }
    }
    
    
    @IBAction func infoButtonDidTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailVC.userPost = post
        self.controller.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()

    }
    
    
    
}
