//
//  PostingViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 18/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD

class PostingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    

    
    var picker = UIImagePickerController()
    
    var finalSex = ""
    var finalSize = ""
    var finalType = ""
    var finalBrand = ""
    var finalCaption = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        picker.delegate = self
        //print(self.finalSex)
        
        
    }
    
    func setupUI() {
    
        setupPostButton()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.previewImage.image = image
            selectButton.isHidden = true
            postButton.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func selectPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion:nil )
    }
    
    @IBAction func postPressed(_ sender: Any) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
        let key = ref.child("items").childByAutoId().key
        let imageRef = storage.child("items").child(uid).child("\(key).jpeg")
        
        
        let data = self.previewImage.image!.jpegData(compressionQuality: 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) {(metadata,error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            imageRef.downloadURL(completion: {(url,error) in
                if let url = url {
                    let feed = ["userID": uid,
                                "image_url": url.absoluteString,
                                "type": self.finalType,
                                "size": self.finalSize,
                                "brand":self.finalBrand,
                                "gender":self.finalSex,
                                "author_profile_url": Auth.auth().currentUser!.photoURL!.absoluteString,
                                "author": Auth.auth().currentUser!.displayName!,
                                "description": self.finalCaption,
                                "postID": key!] as [String : Any]
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("items").updateChildValues(postFeed)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    }
            })
        }
        
        
        uploadTask.resume()
        
        

    
        navigationController?.popViewControllers(viewsToPop: 2)
            
        
        
        
    }

}

extension PostingViewController {
    func setupPostButton() {
        postButton.layer.borderColor = UIColor.black.cgColor
        postButton.layer.borderWidth = 1.0
        postButton.setTitle("Upload Item", for: UIControl.State.normal)
        postButton.setTitleColor(.white, for: UIControl.State.normal)
        postButton.backgroundColor = UIColor.black
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        postButton.layer.cornerRadius = 5
        postButton.clipsToBounds = true    }
}
