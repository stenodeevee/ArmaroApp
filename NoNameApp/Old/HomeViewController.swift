//
//  HomeViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 25/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let captions: PostRenderViewModel
    let actions: PostRenderViewModel
}

class HomeViewController: UIViewController {
    

    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedPostTableViewCell.self,
                           forCellReuseIdentifier: FeedPostTableViewCell.identifier)
        tableView.register(FeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: FeedPostHeaderTableViewCell.identifier)
        tableView.register(FeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: FeedPostActionsTableViewCell.identifier)
        tableView.register(FeedPostGeneralTableViewCell.self,
                           forCellReuseIdentifier: FeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    var postedClothing = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPost()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Items"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let location = UIBarButtonItem(title: "Filter", style: UIBarButtonItem.Style.plain, target: self,action: #selector(locationDidTapped))
        navigationItem.leftBarButtonItem = location
    }
    
    @objc private func locationDidTapped() {
        // switch to items around view controller
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let itemsAroundVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_ITEMS_AROUND) as! ItemsAroundViewController
        
        self.navigationController?.pushViewController(itemsAroundVC,animated: true)
    }
    
      
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

    private func fetchPost() {
                
        let ref = Database.database().reference()
        ref.child("items").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            let postsSnap = snap.value as! [String: AnyObject]
            for (_,items) in postsSnap {
            if let userID = items["userID"] as? String {
                if userID != Auth.auth().currentUser?.uid {
                    let post = Post()
                    
                    
                    if let author = items["author"] as? String, let postID = items["postID"] as? String, let caption = items["description"] as? String, let size = items["size"] as? String, let pathToImage = items["image_url"] as? String, let typeOfClothing = items["type"] as? String, let userImage_url = items["author_profile_url"] as? String, let brand = items["brand"] as? String {
                        
                        
                        post.username = author
                        post.brand = brand
                        post.pathToImage = pathToImage
                        post.userID = userID
                        post.postID = postID
                        post.userImage_url = userImage_url
                        post.caption = caption
                        post.size = size
                        post.typeOfClothing = typeOfClothing
                                
 
                        self.postedClothing.append(post)
                        let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provider: post)),
                                                            post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                                                            captions: PostRenderViewModel(renderType: .caption(provider: post)),
                                                            actions: PostRenderViewModel(renderType: .actions(provider: post)))
                        self.feedRenderModels.append(viewModel)                    }
                                    
                    }
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        ref.removeAllObservers()
    
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource,  FeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        //
    }
    
    func didTapNopeButton() {
        //
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // header
            return 1
        }
        else if subSection == 1 {
            // post
            return 1
        }
        else if subSection == 2 {
            // caption
            return 1
        }
        else if subSection == 3 {
            // actions
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // header
            let headerModel = model.header
            switch headerModel.renderType{
            case .header(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostHeaderTableViewCell.identifier, for: indexPath) as! FeedPostHeaderTableViewCell
                cell.configure(with: post)
                cell.delegate = self
                return cell
            case .actions, .caption, .primaryContent: return UITableViewCell()
                
            }
        }
        else if subSection == 1 {
            // post
            let postModel = model.post
            switch postModel.renderType{
            
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostTableViewCell.identifier, for: indexPath) as! FeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .actions, .caption, .header: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            // caption
            let captionModel = model.captions
            switch captionModel.renderType{
            case .caption(let caption):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostGeneralTableViewCell.identifier, for: indexPath) as! FeedPostGeneralTableViewCell
                cell.configure(with: caption)
                return cell
            case .actions, .header, .primaryContent: return UITableViewCell()            }
        }
        else if subSection == 3 {
            // actions
            let actionModel = model.actions
            switch actionModel.renderType{
            case .actions(let actions):
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostActionsTableViewCell.identifier, for: indexPath) as! FeedPostActionsTableViewCell
                

                
            cell.delegate = self
            return cell
            case .header, .caption, .primaryContent: return UITableViewCell()
                
            }
        }
        return UITableViewCell()
    }
    
    func didTapInfoButton(cell: FeedPostActionsTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell)?.section else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }

        //  Do whatever you need to do with the indexPath
        let row = (indexPath - 3)/4
        print("Button tapped on row \(row)")
        
        //let vc = ChatViewController()
        //vc.title = "Chat"
        //vc.model = postedClothing[row]
        
        guard let otherUserId = postedClothing[row].userID,
              let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        var conversationId : String?
        print("conversationId:", conversationId)
        print("other user id ", otherUserId)
        var conversationBoolean = true
        
        
        StorageService.shared.conversationExists(with: otherUserId, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let conversationId):
                let vc = ChatsViewController(with: conversationId, otherUserId: otherUserId)
                vc.isNewConversation = false
                vc.title = strongSelf.postedClothing[row].username
                //vc.otherUser = strongSelf.postedClothing[row]
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(_):
                let vc = ChatsViewController(with: nil, otherUserId: otherUserId)
                vc.isNewConversation = true
                vc.title = strongSelf.postedClothing[row].username
                //vc.otherUser = strongSelf.postedClothing[row]
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            
        })
        
//        Ref().databaseUsers.child("\(userId)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot
//            in
//            if let conversations = snapshot.value as? [[String: Any]] {
//                for conversation in conversations {
//                    if let otherId = conversation["other_user_id"] as? String, otherId == otherUserId {
//                        print("We found an existing conversation")
//                        conversationId = conversation["id"] as? String
//                        conversationBoolean = false
//                        break
//                    }
//                }
//            }
            
//            let vc = ChatsViewController(with: conversationId, otherUserId: otherUserId)
//            vc.isNewConversation = conversationBoolean
//            vc.title = self?.postedClothing[row].username
//            vc.otherUser = self?.postedClothing[row]
            
//            vc.navigationItem.largeTitleDisplayMode = .never
            
//            self?.navigationController?.pushViewController(vc, animated: true)
//        })
        


        
        

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        if subSection == 0 {
            return 70
        }
        else if subSection == 1 {
            return tableView.bounds.width
        }
        else if subSection == 2 {
            return 50
        }
        else if subSection == 3 {
            return 90
        }
        return 0

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
    
    
}


extension HomeViewController: FeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report", style: .destructive, handler: {[weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func reportPost() {
        
    }
}

/*
extension HomeViewController: FeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
            }
    
    func didTapNopeButton() {
        
    }
    
    func didTapInfoButton() {
        let vc = ChatViewController()
        vc.title = "Chat"
        vc.model = postedClothing[0]
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)

   }
    
    
}
 */

 
