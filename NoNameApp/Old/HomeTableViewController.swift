//
//  HomeTableViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 22/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class HomeTableViewController: UITableViewController {

    var postedClothing = [Post]()
    var traders = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutMargins = UIEdgeInsets.zero
        fetchPost()

    }
    
    func fetchPost() {

        let ref = Database.database().reference()
        ref.child("items").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            let postsSnap = snap.value as! [String: AnyObject]
            for (_,items) in postsSnap {
            if let userID = items["userID"] as? String {
                if userID != Auth.auth().currentUser?.uid {
                    let post = Post()
                    
                    
                    if let author = items["author"] as? String, let postID = items["postID"] as? String, let caption = items["description"] as? String, let size = items["size"] as? String, let pathToImage = items["image_url"] as? String, let typeOfClothing = items["type"] as? String, let userImage_url = items["author_profile_url"] as? String {
                        
                        
                        post.username = author
//                        post.brand = brand
                        post.pathToImage = pathToImage
                        post.userID = userID
                        post.postID = postID
                        post.userImage_url = userImage_url
                        post.caption = caption
                        post.size = size
                        post.typeOfClothing = typeOfClothing
                                
 
                        self.postedClothing.append(post)
                        
                    }
                                    
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        
        ref.removeAllObservers()
    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.postedClothing.count)
        return self.postedClothing.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell


        cell.brandLabel.text = "gucci mami babi sono"
        cell.avatar.loadImage(self.postedClothing[indexPath.row].userImage_url!)
        cell.clothingImage.loadImage(self.postedClothing[indexPath.row].pathToImage!)
        cell.usernameLabel.text = self.postedClothing[indexPath.row].username!
            
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 545
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


