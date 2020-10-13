//
//  ChatViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 29/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    static let identifier = "ChatViewController"
    
    
    
    var model: Post?
    var topLabel : UILabel = UILabel(frame: CGRect(x:0,y:0, width: 200, height: 50))
    var placeholderLabel = UILabel()
//    var topLabel : UILabel = UILabel(frame: CGRect(x:0,y:0, width: 200, height: 50))
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    
    private let profilePhotoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect( x:0, y:0, width: 36, height: 36))
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemBlue
        return imageView
    } ()
    
    private let attachButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "attachment_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private let chatView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let barView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    

    
    private let recordButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "mic")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.lightGray, for: UIControl.State.normal)
        return button
    }()
    
    private let chatTextView : UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupInputContainer()
        addingSubviews()
        
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        
        attachButton.addTarget(self, action: #selector(didTapAttachButton), for: .touchUpInside)
    
        recordButton.addTarget(self, action: #selector(didTapMicButton), for: .touchUpInside)
        
        
        
    }
    
    private func setupInputContainer() {
        
        chatTextView.delegate = self
        
        
        placeholderLabel.isHidden = false

        let placeholderFontSize = self.view.frame.size.width/25
        
        placeholderLabel.text = "Write a message"
        placeholderLabel.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.textAlignment = .left
        
        
    }
    
    @objc private func didTapSendButton() {
        
    }
    
    @objc private func didTapMicButton() {
        
    }
    
    @objc private func didTapAttachButton() {
        
    }
    
    private func addingSubviews() {
        view.addSubview(tableView)
        view.addSubview(chatView)
        view.addSubview(attachButton)
        view.addSubview(recordButton)
        view.addSubview(sendButton)
        view.addSubview(chatTextView)
        view.addSubview(placeholderLabel)
        view.addSubview(barView)
    }
    
    private func setupNavigationBar() {

        navigationItem.largeTitleDisplayMode = .never
        let containView = UIView(frame: CGRect(x:0, y:0, width: 36, height: 36))
        let image = model?.userImage_url
        profilePhotoImageView.loadImage(image)
        profilePhotoImageView.contentMode = .scaleAspectFill
        profilePhotoImageView.layer.cornerRadius = 18
        profilePhotoImageView.clipsToBounds = true
        containView.addSubview(profilePhotoImageView)
        
        let rightBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        let username = (model?.username)!
        let attributed = NSMutableAttributedString(string: username + "\n", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor : UIColor.black] )
        attributed.append(NSAttributedString(string: "Active", attributes: [.font: UIFont.systemFont(ofSize: 13), .foregroundColor: UIColor.green]))
        
        topLabel.attributedText = attributed
        
        self.navigationItem.titleView = topLabel
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
               
        tableView.frame = CGRect(x:0,y:0, width: view.bounds.width, height: view.bounds.height - 100)
        
        chatView.frame = CGRect(x:0, y: view.bounds.height - 99, width: view.bounds.width, height: 99)
        barView.frame = CGRect(x:0, y: view.bounds.height - 100 , width: view.bounds.width, height: 1)
        
        
        attachButton.frame = CGRect(x:8, y: view.bounds.height - 95 , width: 32, height: 32)
        
        recordButton.frame = CGRect(x:48, y: view.bounds.height - 95 , width: 32, height: 32)
        
        chatTextView.frame = CGRect(x:91, y: view.bounds.height - 95 , width: view.bounds.width - 91 - 58, height: 30)
        
        sendButton.frame = CGRect(x: view.bounds.width-58 , y: view.bounds.height - 95 , width: 50, height: 30)
        

        placeholderLabel.frame = CGRect(x:92, y: view.bounds.height - 95, width: view.bounds.width - 91 - 58 , height: 30)
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let spacing = CharacterSet.whitespacesAndNewlines
        if !textView.text.trimmingCharacters(in: spacing).isEmpty {
            let text = textView.text.trimmingCharacters(in: spacing)
            sendButton.isEnabled = true
            sendButton.setTitleColor(.black, for: UIControl.State.normal)
            placeholderLabel.isHidden = true
            
        } else {
            sendButton.isEnabled = false
            sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
            placeholderLabel.isHidden = false
            
        }
    }
}
