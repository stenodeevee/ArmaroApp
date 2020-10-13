//
//  RadarViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 09/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import GeoFire
import CoreLocation
import FirebaseDatabase
import ProgressHUD
import FirebaseAuth

class RadarViewController: UIViewController {
    
    @IBOutlet weak var cardStack: UIView!
    @IBOutlet weak var nopeButton: UIImageView!
    @IBOutlet weak var refreshButton: UIImageView!
    @IBOutlet weak var likeButton: UIImageView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let manager = CLLocationManager()
    let mySlider = UISlider()
    let distanceLabel = UILabel()
    var userLat = ""
    var userLong = ""
    var geoFire: GeoFire!
    var geoFireRef: DatabaseReference!
    var myQuery: GFQuery!
    var queryHandle: DatabaseHandle?
    var distance: Double! = 10
    var UserPosts: [Post] = []
    var currentLocation: CLLocation?
    var cards: [Card] = []
    var cardInitialLocationCenter: CGPoint!
    var panInitialLocation: CGPoint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        setupNavigationBar()
        
        nopeButton.isUserInteractionEnabled = true
        let tapNopeButton = UITapGestureRecognizer(target: self, action: #selector(nopeButtonDidTap))
        nopeButton.addGestureRecognizer(tapNopeButton)

        likeButton.isUserInteractionEnabled = true
        let tapLikeButton = UITapGestureRecognizer(target: self, action: #selector(likeButtonDidTap))
        likeButton.addGestureRecognizer(tapLikeButton)
        
        let newMatchItem = UIBarButtonItem(title: "Matches", style: UIBarButtonItem.Style.plain, target: self, action: #selector(newMatchItemDidTap))
        self.navigationItem.rightBarButtonItem = newMatchItem
        
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Armaro"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let newMatchItem = UIBarButtonItem(title: "Matches", style: UIBarButtonItem.Style.plain, target: self, action: #selector(newMatchItemDidTap))
        self.navigationItem.rightBarButtonItem = newMatchItem
        
        distanceLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        distanceLabel.font = UIFont.systemFont(ofSize: 13)
        distanceLabel.text = "10 km"
        distanceLabel.textColor = .label
        let distanceItem = UIBarButtonItem(customView: distanceLabel)
        
        
        mySlider.frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        mySlider.minimumValue = 1
        mySlider.maximumValue = 150
        mySlider.isContinuous = true
        mySlider.value = Float(30)
        mySlider.tintColor = .label
        mySlider.addTarget(self, action: #selector(sliderValueChanged(slider:event:)), for: UIControl.Event.valueChanged)
        
        
        navigationItem.rightBarButtonItems = [newMatchItem, distanceItem]
        navigationItem.titleView = mySlider
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
                findClothes()
            default:
                break
            }
        }
    }
    
       
    
    @objc func newMatchItemDidTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newMatchVC = storyboard.instantiateViewController(withIdentifier: "NewMatchTableViewController") as! NewMatchTableViewController
        self.navigationController?.pushViewController(newMatchVC, animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        //self.cards.removeAll()
        findClothes()
    }
    
    @objc func nopeButtonDidTap() {
        guard let firstCard = cards.first else {
            return
        }
        saveToFirebase(like: false, card: firstCard)
        swipeAnimation(translation: -750, angle: -15)
        self.setupTransforms()
    }
    
    @objc func likeButtonDidTap() {
        guard let firstCard = cards.first else {
            return
        }
        saveToFirebase(like: true, card: firstCard)
        swipeAnimation(translation: 750, angle: 15)
        self.setupTransforms()
    }
    
    func saveToFirebase(like: Bool, card: Card) {
        guard let currentId = Auth.auth().currentUser?.uid else {
            return
        }
        guard let otherId = card.post.userID as? String else {
            return
        }

        
        Ref().databaseActionForUser(uid: currentId).observeSingleEvent(of: .value, with: {snapshot in
            if let userActions = snapshot.value as? [String:Bool] {
                guard let opinion = userActions["\(otherId)"] else {
                    // first action with THIS user
                    Ref().databaseActionForUser(uid: currentId).updateChildValues([otherId: like], withCompletionBlock: {(error, ref) in
                        if error == nil, like == true {
                            // check if match {send push notification}
                            self.checkIfMatchFor(card:card)
                        }
                    })
                    return
                }
                
                // HAS ALREADY LIKED OR DISLIKED something from this user
                let newlike = like || opinion
                Ref().databaseActionForUser(uid: currentId).updateChildValues([otherId: newlike], withCompletionBlock: {(error, ref) in
                    if error == nil, newlike == true, opinion == false {
                        // User was never liked before
                        // check if match {send push notification}
                        self.checkIfMatchFor(card:card)
                    }
                })
            }
            else {
                // FIRST ACTION EVER
                Ref().databaseActionForUser(uid: currentId).updateChildValues([otherId: like], withCompletionBlock: {(error, ref) in
                    if error == nil, like == true {
                        // check if match {send push notification}
                        self.checkIfMatchFor(card:card)
                    }
                })
            }
        })
    }
    
    func checkIfMatchFor(card: Card) {
        guard let otherId = card.post.userID as? String else {
            return
        }
        guard let currentId = Auth.auth().currentUser?.uid else {
            return
        }
        Ref().databaseActionForUser(uid: otherId).observeSingleEvent(of: .value, with: {snapshot in
            guard let dict = snapshot.value as? [String:Bool] else {return}
            if dict.keys.contains(currentId), dict[currentId] == true {
                print("It's a match")
            }
        })
    }
    
    func swipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        guard let firstCard = cards.first else {
            return
        }
        
        for (index, c) in self.cards.enumerated() {
            if c.post.postID == firstCard.post.postID {
                self.cards.remove(at: index)
                self.UserPosts.remove(at: index)
            }
        }
        
        self.setupGestures()
        
        CATransaction.setCompletionBlock {
            firstCard.removeFromSuperview()
        }
        
        firstCard.layer.add(translationAnimation, forKey: "translation")
        firstCard.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupCard(post: Post) {
        let card: Card = UIView.fromNib()
        card.frame = CGRect(x: 0, y: 0, width: cardStack.bounds.width, height: cardStack.bounds.height)
        card.post = post
        card.controller = self
        cards.append(card)
        cardStack.addSubview(card)
        cardStack.sendSubviewToBack(card)
        
        setupTransforms()
        
        if cards.count == 1 {
            cardInitialLocationCenter = card.center
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    // MARK: Gesture
    @objc func pan(gesture: UIPanGestureRecognizer) {
        let card = gesture.view! as! Card
        let translation = gesture.translation(in: cardStack)
        
        switch gesture.state {
 
        case .began:
            panInitialLocation = gesture.location(in: cardStack)
            print("initial pan location", panInitialLocation)
        case .changed:
            
            card.center.x = cardInitialLocationCenter.x + translation.x
            card.center.y = cardInitialLocationCenter.y + translation.y
            
            if translation.x > 0 {
                //show like icon
            } else {
                // show unlike
            }
            
            card.transform = self.transform(view: card, for: translation)
            
            
        case .ended:
            
            if translation.x > 75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center.x = self.cardInitialLocationCenter.x + 1000
                    card.center.y = self.cardInitialLocationCenter.y + 1000
                    
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                saveToFirebase(like: true, card: card)
                self.updateCards(card: card)
                return
                
            } else if translation.x < -75 {
                UIView.animate(withDuration: 0.3, animations: {
                    card.center.x = self.cardInitialLocationCenter.x - 1000
                    card.center.y = self.cardInitialLocationCenter.y - 1000
                    
                }) { (bool) in
                    // remove card
                    card.removeFromSuperview()
                }
                saveToFirebase(like: false, card: card)
                self.updateCards(card: card)
                return
            }
            
            UIView.animate(withDuration: 0.3) {
                card.center = self.cardInitialLocationCenter
                card.transform = CGAffineTransform.identity
            }
        default:
            break
        }
    }
    
    func updateCards(card: Card) {
        for (index, c) in self.cards.enumerated() {
            if c.post.postID == card.post.postID {
                self.cards.remove(at: index)
                self.cards.remove(at: index)
            }
        }
        
        setupGestures()
        setupTransforms()
    }
    
    func setupGestures() {
        for card in cards {
            let gestures = card.gestureRecognizers ?? []
            for g in gestures {
                card.removeGestureRecognizer(g)
            }
        }
        if let firstCard = cards.first {
            firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:))))
        }
    }
    
    func transform(view: UIView, for translation: CGPoint) -> CGAffineTransform {
        let moveBy = CGAffineTransform(translationX: translation.x, y: translation.y)
        let rotation = -translation.x / (view.frame.width / 2)
        return moveBy.rotated(by: rotation)
    }
    
    
    // MARK: Transform
    func setupTransforms() {
        for (i, card) in cards.enumerated() {
            if i == 0 {continue;}
            if i > 3 {return}
            
            var transform = CGAffineTransform.identity
            if i % 2 == 0 {
                transform = transform.translatedBy(x: CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: CGFloat(Double.pi)/150*CGFloat(i))
            }
            else {
                transform = transform.translatedBy(x: -CGFloat(i)*4, y: 0)
                transform = transform.rotated(by: -CGFloat(Double.pi)/150*CGFloat(i))
            }
            card.transform = transform
        }
        
    }
    
    
    // MARK: Find Clothes
    
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
        self.cards.removeAll()
        
        for view in cardStack.subviews {
            view.removeFromSuperview()
        }
        
        guard let distance = distance as? Double else {
            return
        }
        
        print(myQuery == nil)
        
        guard let myQuery = geoFire?.query(at: location, withRadius: distance) else {
            return
        }
        
        
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
                                        self.setupCard(post: post)
                                    }
                                case 1:
                                    if post.gender == "F" {
                                        
                                        self.UserPosts.append(post)
                                        self.setupCard(post: post)
                                    }
                                case 2:
                                    
                                    self.UserPosts.append(post)
                                    self.setupCard(post: post)
                                default:
                                break
                                }
                                
                                
                                //self.UserPosts.append(post)
                                //self.setupCard(post: post)
                                //print(post.username)
                                
                            }
                        }
                    }
                })
            }
        })
    }
}

// MARK: Extension for CLLocationManagerDelegate

extension RadarViewController: CLLocationManagerDelegate {
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



