//
//  ChatsViewController.swift
//  Armaro
//
//  Created by ESTEFANO on 05/10/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseAuth
import SDWebImage
import AVKit
import AVFoundation

import InputBarAccessoryView

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
    
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attr text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "Link preview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
    public var photoURL: String
    
}

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}


class ChatsViewController: MessagesViewController {
    
    private var senderPhotoUrl: URL?
    private var otherUserPhotoUrl: URL?
    
    public var isNewConversation = false
    private var conversationId: String?
    private let otherUserId: String?
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
        
    }()
    
    //public var otherUser: Post?
    
        
    
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        return Sender(senderId: uid, displayName: Auth.auth().currentUser!.displayName!, photoURL: Auth.auth().currentUser!.photoURL!.absoluteString)

    }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        StorageService.shared.getAllMessagesForConversation(with: id, completion: {[weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                    
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToBottom()
                    }
                }
                
                
            case.failure(let error):
                print("failed to get messages: \(error)")
            }
        })
    }
    
    init(with id: String?, otherUserId: String?) {
        self.conversationId = id
        self.otherUserId = otherUserId
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        

        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        setupInputButton()
        
    }
    
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(UIImage(systemName: "paperclip"), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Media",
                                            message: "What would you like to attach?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentInputPhotoActionSheet()
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Video",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                self?.presentInputVideoActionSheet()
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Audio",
                                            style: .default,
                                            handler: {[weak self] _ in }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil ))
        
        present(actionSheet, animated: true)
    }
    
    
    private func presentInputPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Photo",
                                            message: "Where would you like to get the photo from?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                
                                                let picker = UIImagePickerController()
                                                picker.sourceType = .photoLibrary
                                                picker.delegate = self
                                                picker.allowsEditing = true
                                                self?.present(picker, animated: true)
                                                
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                let picker = UIImagePickerController()
                                                picker.sourceType = .camera
                                                picker.delegate = self
                                                picker.allowsEditing = true
                                                self?.present(picker, animated: true)
                                                
                                            }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil ))
        
        present(actionSheet, animated: true)
    }
    
    private func presentInputVideoActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Video",
                                            message: "Where would you like to get the photo from?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                
                                                let picker = UIImagePickerController()
                                                picker.sourceType = .photoLibrary
                                                picker.delegate = self
                                                picker.mediaTypes = ["public.movie"]
                                                picker.videoQuality = .typeLow
                                                picker.allowsEditing = true
                                                self?.present(picker, animated: true)
                                                
                                            }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera",
                                            style: .default,
                                            handler: {[weak self] _ in
                                                let picker = UIImagePickerController()
                                                picker.sourceType = .camera
                                                picker.delegate = self
                                                picker.mediaTypes = ["public.movie"]
                                                picker.videoQuality = .typeLow
                                                picker.allowsEditing = true
                                                self?.present(picker, animated: true)
                                                
                                            }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil ))
        
        present(actionSheet, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversation_id = conversationId {
            listenForMessages(id: conversation_id, shouldScrollToBottom: true)        }
        
    }
    



}

extension ChatsViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messages.count
    }
    
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
        
        
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        
        switch message.kind {
        

        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            return .systemGreen
        }
        
        return .secondarySystemBackground
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            //show our image
            if let currentUserURL = self.senderPhotoUrl {
                avatarView.sd_setImage(with: currentUserURL, completed: nil)
            }
            else {
                //fetch URL
                // path is profile/userId
                let path = "profile/\(sender.senderId)"
                StorageService.shared.downloadURL(for: path, completion: {[weak self] result in
                    switch result {
                    case .success(let url):
                        self?.senderPhotoUrl = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil)
                        }

                    case .failure(let error):
                        print("\(error)")
                    }
                    
                })
            }
        }
        else {
            // show other user image
            if let otherUserURL = self.otherUserPhotoUrl {
                avatarView.sd_setImage(with: otherUserURL, completed: nil)
            }
            else {
                //fetch URL
                let path = "profile/\(sender.senderId)"
                StorageService.shared.downloadURL(for: path, completion: {[weak self] result in
                    switch result {
                    case .success(let url):
                        self?.otherUserPhotoUrl = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil)
                        }

                    case .failure(let error):
                        print("\(error)")
                    }
                    
                })
                
            }
            
        }
    }
     
}

extension ChatsViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let message = messages[indexPath.section]
            
        switch message.kind {
            

        case .photo(let media):
            guard let imageUrl = media.url else {
                return
            }
            let vc = PhotoViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        case .video(let media):
            guard let videoUrl = media.url else {
                return
            }
            let vc = AVPlayerViewController()
            vc.player = AVPlayer(url: videoUrl)
            present(vc, animated: true)
            
        default:
            break
        }
    }
    
    
}


extension ChatsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let conversationId = self.conversationId,
              let name = self.title,
              let otherUserId = self.otherUserId,
              let selfSender = selfSender,
              let messageId = createMessageId() else {
            return
        }
        
        if let image = info[.editedImage] as? UIImage, let imageData = image.pngData() {
            
            //upload image
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".png"
            StorageService.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let urlString):
                    // ready to send message
                    print("Uploaded Message Photo: \(urlString)")
                    
                    guard let url = URL(string: urlString),
                          let placeholder = UIImage(systemName: "plus") else {
                        return
                    }
                    
                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)
                    
                    
                    let mmessage = Message(sender: selfSender,
                                           messageId: messageId,
                                           sentDate: Date(),
                                           kind: .photo(media) )
                    
                    StorageService.shared.sendMessage(to: conversationId, otherUserId: otherUserId, name: name, newMessage: mmessage, completion: {success in
                        if success {
                            print("sent photo message")
                        }
                        else {
                            print("not sent photo message")
                        }
                        
                    })
                    
                case .failure(let error):
                    print("message photo upload error: \(error)")
                }
            })
            
        }
        
        else if let videoUrl = info[.mediaURL] as? URL {
            
            //Upload a video
            
            let fileName = "photo_message_" + messageId.replacingOccurrences(of: " ", with: "-") + ".mov"
            StorageService.shared.uploadMessageVideo(with: videoUrl, fileName: fileName, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let urlString):
                    // ready to send message
                    print("Uploaded Message Video: \(urlString)")
                    
                    guard let url = URL(string: urlString),
                          let placeholder = UIImage(systemName: "plus") else {
                        return
                    }
                    
                    let media = Media(url: url,
                                      image: nil,
                                      placeholderImage: placeholder,
                                      size: .zero)
                    
                    
                    let mmessage = Message(sender: selfSender,
                                           messageId: messageId,
                                           sentDate: Date(),
                                           kind: .video(media) )
                    
                    StorageService.shared.sendMessage(to: conversationId, otherUserId: otherUserId, name: name, newMessage: mmessage, completion: {success in
                        if success {
                            print("sent video message")
                        }
                        else {
                            print("not sent video message")
                        }
                        
                    })
                    
                case .failure(let error):
                    print("message video upload error: \(error)")
                }
            })        }
           
        
        
        
        

        // send message
    }
}


extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else {
            
            print(!text.replacingOccurrences(of: " ", with: "").isEmpty)
            return
        }
        
        print("sending: \(text)")
        
        // send message to DB
        let mmessage = Message(sender: selfSender,
                               messageId: messageId,
                               sentDate: Date(),
                               kind: .text(text))
        
        if isNewConversation{
            guard let otherUserId = otherUserId else {
                return
            }
            
            StorageService.shared.createNewConversation(with: otherUserId, nname: self.title ?? "User" , firstMessage: mmessage, completion: { [weak self] success in
                if success {
                    print("create new conversation and message sent")
                    self?.isNewConversation = false
                    let newConversationId = "conversation_\(mmessage.messageId)"
                    self?.conversationId = newConversationId
                    self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                    self?.messageInputBar.inputTextView.text = nil
                }
                else {
                    print("not sent")
                }
            })
            
        }
        else {
                        
            guard let conversationId = conversationId,
                  let name = self.title,
                  let otherUserId = otherUserId else {
                return
            }
            StorageService.shared.sendMessage(to: conversationId, otherUserId: otherUserId, name: name, newMessage: mmessage, completion: { [weak self] success in
                
                if success {
                    print("additional message sent")
                    self?.messageInputBar.inputTextView.text = nil
                }
                else {
                    print("failed to send additional message")
                }
            })
        }
    }
    
    private func createMessageId() -> String? {
        // date, otherUserEmail, senderEmail
        
        guard let currentUserId = Auth.auth().currentUser?.uid,
              let otherUserId = otherUserId else {
            
            return nil
        }
        
        let dateString = Self.dateFormatter.string(from:Date())
        let newIdentifier = "\(otherUserId)_\(currentUserId)_\(dateString)"
        //print("create message id: \(newIdentifier)")
        return newIdentifier
    }
    
}
