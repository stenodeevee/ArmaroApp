//
//  ItemsAroundViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 07/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import CoreLocation
import GeoFire
import FirebaseDatabase
import ProgressHUD
import FirebaseAuth

class ItemsAroundViewController: UIViewController {

    @IBOutlet weak var mapViewButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    let mySlider = UISlider()
    let distanceLabel = UILabel()
    let manager = CLLocationManager()
    var userLat = ""
    var userLong = ""
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    var myQuery: GFQuery!
    var queryHandle: DatabaseHandle?
    var distance: Double = 500
    var UserPosts: [Post] = []
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        configureLocationManager()
        // Do any additional setup after loading the view.
    }
    
    func configureLocationManager() {
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = true
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        self.geoFireRef = Ref().databaseGeo
        self.geoFire = GeoFire(firebaseRef: self.geoFireRef)
    }
    
    func findClothes() {
        if queryHandle != nil, myQuery != nil {
            myQuery.removeObserver(withFirebaseHandle: queryHandle!)
            myQuery = nil
            queryHandle = nil
        }
        
        guard let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
              let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String else {
            return
        }
        
        let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))
        self.UserPosts.removeAll()
        
        myQuery = geoFire.query(at: location, withRadius: distance)
        queryHandle = myQuery.observe(GFEventType.keyEntered, with: {(key, location) in
            print(key)
            guard let userId = Auth.auth().currentUser?.uid else {
                print("not retrieved user Id")
                return
            }
            
            if key != userId {
                
                
                
                let ref = Database.database().reference()
                ref.child("items").observeSingleEvent(of: .value, with: {snapshot in
                
                    guard let items = snapshot.value as? [String: AnyObject] else {
                        print("nothing found")
                        return
                    }
                    

                        
                    for (_,item) in items {
                        if let uid = item["userID"] as? String, uid == key {
                            
                            let post = Post()
                            
                            
                            if let author = item["author"] as? String, let postID = item["postID"] as? String, let caption = item["description"] as? String, let size = item["size"] as? String, let pathToImage = item["image_url"] as? String, let typeOfClothing = item["type"] as? String, let userImage_url = item["author_profile_url"] as? String, let brand = item["brand"] as? String, let gender = item["gender"] as? String {
                                
                                
                                post.username = author
                                post.brand = brand
                                post.pathToImage = pathToImage
                                post.userID = key
                                post.postID = postID
                                post.userImage_url = userImage_url
                                post.caption = caption
                                post.size = size
                                post.typeOfClothing = typeOfClothing
                                post.gender = gender
                                        
                                switch self.segmentControl.selectedSegmentIndex{
                                case 0:
                                    if post.gender == "M" {
                                        self.UserPosts.append(post)
                                    }
                                case 1:
                                    if post.gender == "F" {
                                        self.UserPosts.append(post)
                                    }
                                case 2:
                                    self.UserPosts.append(post)
                                default:
                                break
                                }
                                    
                                    self.collectionView.reloadData()
                                
                            }
                            
                        }
                    }
                })
                
                
            }
        })
    }
                            
        
    
    private func setupNavigationBar() {
        navigationItem.title = "Clothes around you"
        navigationController?.navigationBar.prefersLargeTitles = true

        let refresh = UIBarButtonItem(image: UIImage(named: "icon-refresh"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(refreshTapped))
        
        
        distanceLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        distanceLabel.text = "30 km"
        distanceLabel.textColor = .label
        let distanceItem = UIBarButtonItem(customView: distanceLabel)
        
        
        mySlider.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        mySlider.minimumValue = 1
        mySlider.maximumValue = 150
        mySlider.isContinuous = true
        mySlider.value = Float(30)
        mySlider.tintColor = .label
        mySlider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: UIControl.Event.valueChanged)
        
        
        navigationItem.rightBarButtonItems = [refresh, distanceItem]
        navigationItem.titleView = mySlider
    }
    
    @objc private func refreshTapped() {
        findClothes()
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        findClothes()
    }
    
    @objc private func sliderValueChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            distance = Double(slider.value)
            distanceLabel.text = "\(Int(slider.value)) km"
            
            switch touchEvent.phase {
            
            case .began:
                print("began")
            case .moved:
                print("moved")
            case .ended:
                print("ended")
            default:
                break
            }
        }
    }
}

extension ItemsAroundViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of posts",self.UserPosts.count)
        return self.UserPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.bounds.size.width)/3-2, height: (view.bounds.size.width)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsAroundCollectionViewCell", for: indexPath) as! ItemsAroundCollectionViewCell
        
        let post = UserPosts[indexPath.item]
        cell.controller = self
        cell.loadData(post, currentLocation: self.currentLocation)
        

       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ItemsAroundCollectionViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
            detailVC.userPost = cell.post        
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
                
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}

extension ItemsAroundViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ProgressHUD.showError("\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil

        let updatedLocation: CLLocation = locations.first!
        let newCoordinate: CLLocationCoordinate2D = updatedLocation.coordinate
        self.currentLocation = updatedLocation
        
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set("\(newCoordinate.latitude)", forKey: "current_location_latitude")
        userDefaults.set("\(newCoordinate.longitude)", forKey: "current_location_longitude")
        userDefaults.synchronize()
        
        if let userLat = UserDefaults.standard.value(forKey: "current_location_latitude") as? String,
           let userLong = UserDefaults.standard.value(forKey: "current_location_longitude") as? String {
            let location: CLLocation = CLLocation(latitude: CLLocationDegrees(Double(userLat)!), longitude: CLLocationDegrees(Double(userLong)!))

            
            guard let currentUserId = Auth.auth().currentUser?.uid else {
                return
            }
            
            Ref().databaseSpecificUser(uid: currentUserId).updateChildValues(["current_latitude": userLat, "current_longitude": userLong])
            
            
            self.geoFire.setLocation(location, forKey: currentUserId) { (error) in
                if error == nil {
                    // Find clothes near user
                    self.findClothes()
                }
            }
        }
        
    }
}
