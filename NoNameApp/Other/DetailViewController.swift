//
//  DetailViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 09/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clothesImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    
    var userPost: Post!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImg = UIImage(named: "close")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        backButton.setImage(backImg, for: .normal)
        backButton.tintColor = .white
        backButton.layer.cornerRadius = 35/2
        backButton.clipsToBounds = true
        
        clothesImageView.loadImage(userPost.pathToImage)
        
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        clothesImageView.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        
        
        sizeLabel.text = userPost.size
        brandLabel.text = userPost.brand.uppercased()
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
         
        
  
    
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }


}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.textLabel?.text = userPost.caption
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.imageView?.loadImage(userPost.userImage_url)
            cell.textLabel?.text = userPost.username
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapTableViewCell
            
            let refUser = Ref().databaseSpecificUser(uid: userPost.userID)
            refUser.observeSingleEvent(of: .value, with: { snapshot in
                if let user = snapshot.value as? [String:Any] {
                    
                    guard let latitude = user["current_latitude"] as? String,
                          let longitude = user["current_longitude"] as? String else {
                        print("we don't know his position")
                        
                        return
                    }
                    
                    let userLocation = CLLocation(latitude: CLLocationDegrees(Double(latitude)!), longitude: CLLocationDegrees(Double(longitude)!))
                    
                    cell.configure(location: userLocation)
                }
            })
            
            cell.selectionStyle = .none
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 300
        }
        return 44
    }
    
    
}
