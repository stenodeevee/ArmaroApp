//
//  NewMatchTableViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 09/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewMatchTableViewController: UITableViewController {

    var matchesIDs : [String] = []
    var userMatched: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        findMatches()
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "New Matches"
        
        let iconView = UIImageView(image: UIImage(named: "icon_top"))
        iconView.contentMode = .scaleAspectFit
        navigationItem.titleView = iconView
    }
    
    func findMatches() {
        
        
        guard let currentId = Auth.auth().currentUser?.uid else {
            return
        }
        
        Ref().databaseActionForUser(uid: currentId).observeSingleEvent(of: .value, with: {snapshot in
            guard let dict = snapshot.value as? [String:Bool] else {return}
            for key in dict.keys {
                if dict[key] == true {
                    Ref().databaseActionForUser(uid: key).observeSingleEvent(of: .value, with: { snapshot in
                        guard let dict2 = snapshot.value as? [String:Bool] else {return}
                        if dict2.keys.contains(currentId), dict2[currentId] == true {
                            //print(key)
                            Api.User.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
                                //print(user.username)
                                self.userMatched.append(user)
                                print(self.userMatched.count)
                                self.tableView.reloadData()
                                
                            })
                            
                            
                        }
                    })
                }
            }
        })
          
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userMatched.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       
        let user = userMatched[indexPath.row]

 
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchesTableViewCell", for: indexPath) as! MatchesTableViewCell
        cell.controller = self
        cell.loadData(user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userMatched[indexPath.row]
        guard let otherUserId = user.uid as? String else {
            return
        }
        
        StorageService.shared.conversationExists(with: otherUserId, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let conversationId):
                let vc = ChatsViewController(with: conversationId, otherUserId: otherUserId)
                vc.isNewConversation = false
                vc.title = user.username
                //vc.otherUser = strongSelf.postedClothing[row]
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
                
            case .failure(_):
                let vc = ChatsViewController(with: nil, otherUserId: otherUserId)
                vc.isNewConversation = true
                vc.title = user.username
                //vc.otherUser = strongSelf.postedClothing[row]
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}


