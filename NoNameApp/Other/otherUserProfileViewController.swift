//
//  otherUserProfileViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 13/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class otherUserProfileViewController: UIViewController {
    
    static let identifier = "otherUserProfileViewController"
    
    var userPosts = [Post]()
    private var collectionView: UICollectionView?
    var otherUserId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersPost()
        
        
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
        collectionView?.register(otherUserProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: otherUserProfileCollectionReusableView.identifier)
        
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    

    func fetchUsersPost() {

        let ref = Ref().databaseRoot
        ref.child("items").queryOrderedByKey().observeSingleEvent(of: .value, with: { [weak self] (snap) in
            let postsSnap = snap.value as! [String: AnyObject]
            for (_,items) in postsSnap {
            if let userID = items["userID"] as? String {
                if userID == self?.otherUserId {
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


extension otherUserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
       
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
        
        //let vc = PostViewController(model: model)
        //vc.title = "Item"
        //vc.navigationItem.largeTitleDisplayMode = .never
        //navigationController?.pushViewController(vc, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailVC.userPost = model
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: otherUserProfileCollectionReusableView.identifier, for: indexPath) as! otherUserProfileCollectionReusableView
        
        header.otherUserId = self.otherUserId as? String
        
        //header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height/5)
        }
        
        return .zero
    }

    
}

extension otherUserProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        let vc = EditProfileViewController()
        vc.title = "Edit profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
