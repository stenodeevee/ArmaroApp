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

    var otherMatchesIDs : [String] = []
    var yourMatcheIDs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        findMatches()
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Trades"
        
        let iconView = UIImageView(image: UIImage(named: "icon_top"))
        iconView.contentMode = .scaleAspectFit
        navigationItem.titleView = iconView
    }
    
    func findMatches() {
        
        guard let currentId = Auth.auth().currentUser?.uid else {
            return
        }
        Ref().databaseSpecificUser(uid: currentId).child("matches").observeSingleEvent(of: .value, with: {snapshot in
            guard let matches = snapshot.value as? [String:Any] else {
                print("No matches yet")
                return
            }
            for key in matches.keys {
                guard let match = matches[key] as? [String:Any] else {
                    return
                }
                
                let currentItem = match["your_post"] as! String
                let otherItem = match["other_post"] as! String
                
                self.otherMatchesIDs.append(otherItem)
                self.yourMatcheIDs.append(currentItem)
                self.tableView.reloadData()
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
        return self.otherMatchesIDs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       
        let otherUserPostID = otherMatchesIDs[indexPath.row]
        let currentUserPostID = yourMatcheIDs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchesTableViewCell", for: indexPath) as! MatchesTableViewCell
        cell.controller = self
        cell.loadData(currentUserPostID, otherUserPostID: otherUserPostID)
        cell.selectionStyle = .none
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let otherUserPostID = otherMatchesIDs[indexPath.row]
        let currentUserPostID = yourMatcheIDs[indexPath.row]
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ExchangeViewController") as! ExchangeViewController
        vc.otherPostID = otherUserPostID
        vc.yourPostID = currentUserPostID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //
            let otherUserPostID = otherMatchesIDs[indexPath.row]
            let currentUserPostID = yourMatcheIDs[indexPath.row]
            
            tableView.beginUpdates()
            self.otherMatchesIDs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            StorageService.shared.deleteMatch(otherPostId: otherUserPostID, currentPostId: currentUserPostID, completion: { success in
                if !success {
                    print("failed to delete for current user")
                }
            })
            tableView.endUpdates()
            
            // delete it for other guy as well
            StorageService.shared.deleteMatch(otherPostId: currentUserPostID, currentPostId: otherUserPostID, completion: { success in
                if !success {
                    print("failed to delete for other user")
                }
            })
        }
    }}


