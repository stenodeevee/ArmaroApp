//
//  ProfileViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 24/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

/// Profile view controller
final class ProfileViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
    //introduce user posts
    var userPosts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // posts are fetched in the viewWillLoad func so
        
        // layouts
        view.backgroundColor = .systemBackground
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top:0, left: 1, bottom:0, right:1)
        let size = (view.bounds.size.width - 4)/3
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = .systemBackground
        
        // cell
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        // headers
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUsersPost()
    }
    
    func fetchUsersPost() {
        
        self.userPosts.removeAll()
        let ref = Database.database().reference()
        ref.child("items").queryOrderedByKey().observeSingleEvent(of: .value, with: { [weak self] (snap) in
            guard let postsSnap = snap.value as? [String: AnyObject] else {
                return
            }
            for (_,items) in postsSnap {
            if let userID = items["userID"] as? String {
                if userID == Auth.auth().currentUser?.uid {
                    let userPost = Post()
                    
                    
                    if let author = items["author"] as? String, let postID = items["postID"] as? String, let caption = items["description"] as? String, let size = items["size"] as? String, let pathToImage = items["image_url"] as? String, let typeOfClothing = items["type"] as? String, let userImage_url = items["author_profile_url"] as? String, let brand = items["brand"] as? String {
                        
                        
                        userPost.username = author
                        userPost.brand = brand
                        userPost.pathToImage = pathToImage
                        userPost.userID = userID
                        userPost.postID = postID
                        userPost.userImage_url = userImage_url
                        userPost.caption = caption
                        userPost.size = size
                        userPost.typeOfClothing = typeOfClothing
                                
                        
                        self?.userPosts.append(userPost)
                        
                    }
                                    
                    }
                }
            }
            self?.collectionView?.reloadData()
        })
        
        ref.removeAllObservers()
    
    }



}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
       
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(self.userPosts.count)
        return self.userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.userPosts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: model)
        //cell.configure(debug: "test")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let model = userPosts[indexPath.row]

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailVC.userPost = model
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height/5)
        }
        
        return .zero
    }
    


    
}

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.title = "Edit profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
