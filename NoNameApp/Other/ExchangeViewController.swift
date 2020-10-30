//
//  ExchangeViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 14/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    //outlet for tableview, clothesImageView, backbutton,
    //brand label, sizeLabel, otherUserFace
    //yourclothesImageView
    @IBOutlet weak var theirClothesImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var theirAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    var otherPostID: String!
    var yourPostID: String!
    var caption: String!

    
    //action backButtonDidTapped
    @IBAction func backButtonDidTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImg = UIImage(named: "close")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        backButton.setImage(backImg, for: .normal)
        backButton.tintColor = .white
        backButton.layer.cornerRadius = 35/2
        backButton.clipsToBounds = true
        
        theirAvatar.layer.cornerRadius = 25
        theirAvatar.clipsToBounds = true
        
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        theirClothesImageView.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
        
        Api.Post.getPostInforSingleEvent(postID: otherPostID, onSuccess: { [weak self] (post) in
            guard let postImage = post.pathToImage,
                  let sizeText = post.size,
                  let brandText = post.brand,
                  let userphotoImage = post.userImage_url else {
                print("couldn't retrieve post")
                return
            }
            self?.theirAvatar.loadImage(userphotoImage)
            self?.theirClothesImageView.loadImage(postImage)
            self?.sizeLabel.text = sizeText
            self?.brandLabel.text = brandText.uppercased()
             
        })
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        
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

extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            Api.Post.getPostInforSingleEvent(postID: otherPostID, onSuccess: {(post) in
                guard let caption = post.caption else {
                    return
                }
                cell.textLabel?.text = caption
                cell.textLabel?.numberOfLines = 0
            })
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatOrNotTableViewCell", for: indexPath) as! ChatOrNotTableViewCell
            Api.Post.getPostInforSingleEvent(postID: otherPostID, onSuccess: {(post) in
                guard let targetID = post.userID else {
                    return
                }
                cell.targetUserID = targetID
            })
            
            cell.otherPostId = otherPostID
            cell.yourPostId = yourPostID
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourClothesTableViewCell", for: indexPath) as! YourClothesTableViewCell
            cell.configure(postID: yourPostID)
            cell.selectionStyle = .none
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else if indexPath.row == 1 {
            return 80
        }
        
        return 300
        
    }
    
    
}

// MARK: Chat tapping

extension ExchangeViewController: ChatOrNotTableViewCellDelegate {
    func refuseDidTapButton(_ cell: ChatOrNotTableViewCell) {
        guard let otherPostId = self.otherPostID,
              let currentPostId = self.yourPostID else {
            return
        }
        // delete match for current user
        StorageService.shared.deleteMatch(otherPostId: otherPostId, currentPostId: currentPostId, completion: { success in
            if !success {
                print("failed to delete") 
            }
        })
        // delete it for the other user
        StorageService.shared.deleteMatch(otherPostId: currentPostId, currentPostId: otherPostId, completion: { success in
            if !success {
                print("failed to delete")
            }
        })
        
        navigationController?.popViewController(animated: true)
        
        
    }
    
    func chatDidTapButton(_ cell: ChatOrNotTableViewCell) {
        print("tapped on chat")
        guard let otherPostId = self.otherPostID,
              let currentPostId = self.yourPostID else {
            return
        }
        
        StorageService.shared.conversationExists(with: otherPostId, postID: currentPostId, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let conversationId):
                let vc = ChatViewController(with: conversationId, currentPostId: currentPostId, otherPostId: otherPostId)
                vc.isNewConversation = false
                
                Api.Post.getPostInforSingleEvent(postID: otherPostId, onSuccess: {(post) in
                    vc.title = post.username
                    vc.otherPhoto = post.userImage_url
                })
                
                Api.Post.getPostInforSingleEvent(postID: currentPostId, onSuccess: {(post) in
                    vc.senderName = post.username
                    vc.senderPhoto = post.userImage_url
                })
                
                
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(_):
                
                print("it's a new conversation")
                
                let vc = ChatViewController(with: nil, currentPostId: currentPostId, otherPostId: otherPostId)
                vc.isNewConversation = true
                
                Api.Post.getPostInforSingleEvent(postID: otherPostId, onSuccess: {(post) in
                    vc.title = post.username
                })
                
                Api.Post.getPostInforSingleEvent(postID: currentPostId, onSuccess: {(post) in
                    vc.senderName = post.username
                    vc.senderPhoto = post.userImage_url
                })
                
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}
