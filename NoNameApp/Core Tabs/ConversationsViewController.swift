//
//  ConversationsViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 05/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
import FirebaseMessaging

struct Conversation {
    let id: String
    let name: String
    let otherPostId: String
    let currentPostId: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

class ConversationsViewController: UIViewController {
    
    
    
    
    private let spinner = JGProgressHUD(style: .dark)
    private var userConversations = [Conversation]()
    private var postConversations = [Conversation]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No conversations!"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(didTapComposeButton))
        
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        setupTableView()
        startListeningForConversations()
        navigationItem.title = "Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Api.User.currentUserId.isEmpty {
            Messaging.messaging().subscribe(toTopic: Api.User.currentUserId)
        }
    }
    
    private func startListeningForConversations() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        Ref().databaseRoot.child("items").observeSingleEvent(of: .value, with: {snapshot in
            guard let items = snapshot.value as? [String: AnyObject] else {
                print("nothing found")
                return
            }
                       
                
            for (_,item) in items {
                if let userID = item["userID"] as? String, userID == uid {
                    guard let postID = item["postID"] as? String else {
                        return
                    }
                    StorageService.shared.getAllConversation(for: postID, completion: {[weak self] result in
                        switch result {
                            case .success(let conversations):
                                guard !conversations.isEmpty else {
                                    return
                                }
                                
                                self?.noConversationsLabel.isHidden = true
                                self?.tableView.isHidden = false

                                // if empty just put all data
                                if self!.userConversations.isEmpty {
                                    print("no conversations")
                                    self?.userConversations.append(contentsOf: conversations)
                                }
                                
                                var pos = 0
                                // check if it contains already the same conversation
                                for existingConversation in self!.userConversations {
                                    //start from first conversation in the array, so pos=0
                                    innerLoop: for conversation in conversations {
                                        if conversation.id == existingConversation.id {
                                            self!.userConversations[pos] = conversation
                                            print("found existing conv at ", pos)
                                            break innerLoop
                                        }
                                    }
                                    // check other position
                                    pos += 1
                                    print("Position changed to:", pos)
                                
                                }
                                
                                for conversation in conversations {
                                    // get all new conversation
                                    var found = false
                                    for existingConversation in self!.userConversations {
                                        if conversation.id == existingConversation.id {
                                            found = true
                                        }
                                    }
                                    if found == false {
                                        self?.userConversations.append(conversation)
                                    }
                                }
                                
                                

                                
                                print(self!.userConversations)

                                
                                DispatchQueue.main.async {
                                    self?.tableView.reloadData()
                                }
                                
                            case .failure(let error):
                                print("failed to get convos: \(error)")
                        }
                    })
                    
                }

                
            }
            guard !self.userConversations.isEmpty else {
                self.tableView.isHidden = true
                self.noConversationsLabel.isHidden = false
                return
            }
        })

    }
    
    @objc private func didTapComposeButton() {
        let actionSheet = UIAlertController(title: "Log Out", message: "Are you sure you want to Log Out?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive,  handler: {
            _ in Api.User.logOut()        }))
        
        present(actionSheet, animated: true)
    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noConversationsLabel.frame = CGRect(x: 10, y: (view.bounds.height - 100) / 2, width: view.bounds.width - 20, height: 100)
    }
    

    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    
    
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of open conversations is",userConversations.count)
        return userConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        let model = userConversations[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = userConversations[indexPath.row]
        openConversation(model)
        

    }
    
    func openConversation(_ model: Conversation) {
        
        let vc = ChatViewController(with: model.id, currentPostId: model.currentPostId, otherPostId: model.otherPostId)
        vc.isNewConversation = false
        vc.title = model.name
        
        Api.Post.getPostInforSingleEvent(postID: model.otherPostId, onSuccess: {(post) in
           vc.otherPhoto = post.userImage_url
           })
        
        Api.Post.getPostInforSingleEvent(postID: model.currentPostId, onSuccess: {(post) in
            vc.senderPhoto = post.userImage_url
            vc.senderName = post.username
           })
                                            
        
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //
            let conversationId = userConversations[indexPath.row].id
            let currentPostId = userConversations[indexPath.row].currentPostId
            
            tableView.beginUpdates()
            self.userConversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            StorageService.shared.deleteConversation(conversationId: conversationId, currentPostId: currentPostId, completion: { success in
                if !success {
                    print("failed to delete")
                }
            })
            tableView.endUpdates()
        }
    }
    
    
    

    


}
