//
//  StorageService.swift
//  Armaro
//
//  Created by ESTEFANO on 14/09/20.
//  Copyright © 2020 RSL. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD
import MessageKit


final class StorageService {
    
    private let database = Database.database().reference()
    
    static let shared = StorageService()
    
    static func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String,Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        storageProfileRef.putData(data, metadata: metadata, completion:
            {(StorageMetadata, error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                
                storageProfileRef.downloadURL(completion: {(url,error) in
                    if let metaImageUrl = url?.absoluteString {
                        
                        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                            changeRequest.photoURL = url
                            changeRequest.displayName = username
                            changeRequest.commitChanges(completion: {(error) in
                                if let error = error {
                                    ProgressHUD.showError(error.localizedDescription)
                                }
                            })
                        }
                        
                        var dictTemp = dict
                        dictTemp[PROFILE_IMAGE_URL] = metaImageUrl
                        
                        Ref().databaseSpecificUser(uid: uid).updateChildValues(dictTemp, withCompletionBlock: {(error,ref) in
                            if error == nil {
                                onSuccess()
                            } else{
                                onError(error!.localizedDescription)
                            }
                        })
                    }
                })
        })
        
        
    }
}

extension StorageService {
    
    /*
     "" {
        "messages" : [
                { id: String
                type: text,photo
                content:
                date: Date()
                sender_id
                isRead
                }
     
         conversation => [
         [ "conversation_id":
            "other_user_id":
            "latest_message": => {
            "date: Date()
            "latest_message":
            "is_read" : true/false
     
     */
    
    /// Creates new conversation with target user ID and first message sent
    public func createNewConversation(with otherUserId: String, nname: String, firstMessage: Message, completion: @escaping (Bool) -> Void ) {
        guard let currentId = Auth.auth().currentUser?.uid,
              let currentName = Auth.auth().currentUser?.displayName else {
            return
        }
        let ref = database.child(REF_USER).child("\(currentId)")
        ref.observeSingleEvent(of: .value, with: { [weak self ] snapshot in
            guard var userNode = snapshot.value as? [String: Any]  else {
                completion(false)
                print("user not found")
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ChatsViewController.dateFormatter.string(from: messageDate)
            var message = ""
            
            switch firstMessage.kind {
            
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let conversationId = "conversation_\(firstMessage.messageId)"
            
            let newConversationData: [String: Any] = [
                "id" : conversationId,
                "other_user_id": otherUserId,
                "name": nname,
                "latest_message": [
                    "data": dateString,
                    "message": message,
                    "is_read" : false ] ]
            
            let recipient_newConversationData: [String: Any] = [
                "id" : conversationId,
                "other_user_id": currentId,
                "name": currentName,
                "latest_message": [
                    "data": dateString,
                    "message": message,
                    "is_read" : false ] ]
            
            ///update recipient conversation entry
            
            self?.database.child("users/\(otherUserId)/conversations").observeSingleEvent(of: .value, with: { [weak self ] snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    //append
                    conversations.append(recipient_newConversationData)
                    self?.database.child("users/\(otherUserId)/conversations").setValue([conversations])
                }
                else {
                    self?.database.child("users/\(otherUserId)/conversations").setValue([recipient_newConversationData])
                    
                }
            })
            
            /// update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                // conversation array exists for current user
                // append
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: {[weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: nname, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                })
                
            }
            else {
                // conversation array does not exist
                userNode["conversations"] = [
                    newConversationData
                ]
                
                ref.setValue(userNode, withCompletionBlock: {[weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: nname, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                
                })
                    
            }
        })
    }
    
    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void ) {
 //       { "id": String,
 //       "type": text ,
 //       "content": ,
 //       "date": Date(),
 //           "sender_id": ,
 //           "isRead": ,
 //       }
        
        var content = ""
        
        switch firstMessage.kind {
        
        case .text(let messageText):
            content = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        
        let messageDate = firstMessage.sentDate
        let dateString = ChatsViewController.dateFormatter.string(from: messageDate)
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let message: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": content,
            "date": dateString,
            "sender_id": currentUserId,
            "is_read": false,
            "name": name
        ]
        
        let value: [String: Any] = [
        
            "messages": [
            message]
            
        ]
        
        
        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }


    /// Fetches and returns all conversations for the current user with passed in email
    public func getAllConversation(for userId: String, completion: @escaping (Result<[Conversation],Error>) -> Void ) {
        database.child("users/\(userId)/conversations").observe(.value, with: {snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                return
            }
            
            let conversations: [Conversation] = value.compactMap({dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserId = dictionary["other_user_id"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["data"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                    return nil
                }
                let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
                return Conversation(id: conversationId, name: name, otherUserId: otherUserId, latestMessage: latestMessageObject)
            })
            
            
            completion(.success(conversations))
        })
    }

    /// Gets all messages for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message],Error>) -> Void ) {
        print(id)
        database.child("\(id)/messages").observe(.value, with: {snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                return
            }
            

            
            
            let messages: [Message] = value.compactMap({dictionary in
                guard let name = dictionary["name"] as? String,
                      let messageID = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderID = dictionary["sender_id"] as? String,
                      let type = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let is_read = dictionary["is_read"] as? Bool,
                      let date = ChatsViewController.dateFormatter.date(from: dateString) else {
                    return nil
                    
                }
            
                
                let sender = Sender(senderId: senderID,
                                    displayName: name,
                                    photoURL: "")
                
                var kind : MessageKind?
                if type == "photo" {
                    guard let imageUrl = URL(string: content),
                          let placeHolder = UIImage(systemName: "plus") else {
                        return nil
                    }
                    let media = Media(url: imageUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .photo(media)
                }
                else if type == "video" {
                    guard let videoUrl = URL(string: content),
                          let placeHolder = UIImage(systemName: "plus") else {
                        return nil
                    }
                    let media = Media(url: videoUrl,
                                      image: nil,
                                      placeholderImage: placeHolder,
                                      size: CGSize(width: 300, height: 300))
                    kind = .video(media)
                    
                }
                else {
                    kind = .text(content)
                }
                
                guard let finalKind = kind else {
                    return nil
                }
                
                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               kind: finalKind)
            })
            
            completion(.success(messages))
        })    }


    /// sends a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserId: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void ) {
        // add new message to messages
        // update sender latest message
        // update recipient latest message
        
        guard let currentId = Auth.auth().currentUser?.uid  else {
            completion(false)
            return
        }
        
        
        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            var content = ""
            
            switch newMessage.kind {
            
            case .text(let messageText):
                content = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    content = targetUrlString
                }
            case .video(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    content = targetUrlString
                }
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            
            let messageDate = newMessage.sentDate
            let dateString = ChatsViewController.dateFormatter.string(from: messageDate)
            
            guard let currentUserId = Auth.auth().currentUser?.uid else {
                completion(false)
                return
            }
            
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": content,
                "date": dateString,
                "sender_id": currentUserId,
                "is_read": false,
                "name": name
            ]
            currentMessages.append(newMessageEntry)
            
            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    
                    completion(false)
                    return
                }
                
                completion(true)
                
                strongSelf.database.child("users/\(currentId)/conversations").observeSingleEvent(of: .value, with: {snapshot in
                    var databaseEntryConversations = [[ String : Any]]()
                    let updatedValue: [String:Any] = [

                        "data": dateString,
                        "is_read": false,
                        "message": content
                       
                    ]
                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
                        // we need to create conversation entry

                        
                        var targetConversation: [String:Any]?
                        var position = 0
                        
                        for userConversation in currentUserConversations {
                            if let currentId = userConversation["id"] as? String, currentId == conversation {
                                targetConversation = userConversation
                                break
                                }
                            position += 1
                        }
                        
                        if var targetConversation = targetConversation {
                            targetConversation["latest_message"] = updatedValue
                            currentUserConversations[position] = targetConversation
                            databaseEntryConversations = currentUserConversations
                        }
                        
                        else {
                            let newConversationData: [String: Any] = [
                                "id" : conversation,
                                "other_user_id": otherUserId,
                                "name": name,
                                "latest_message": updatedValue
                            ]
                            currentUserConversations.append(newConversationData)
                            databaseEntryConversations = currentUserConversations
                        }
                    }
                    
                    else {
                        
                        let newConversationData: [String: Any] = [
                            "id" : conversation,
                            "other_user_id": otherUserId,
                            "name": name,
                            "latest_message": updatedValue
                        ]
                        databaseEntryConversations = [
                            newConversationData
                        ]
                    }
 
                    strongSelf.database.child("users/\(currentId)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        // update latest message for recipient user
                        
                            
                        strongSelf.database.child("users/\(otherUserId)/conversations").observeSingleEvent(of: .value, with: {snapshot in
                            guard let currentName = Auth.auth().currentUser?.displayName else {
                                return
                            }
                            
                            var databaseEntryConversations = [[ String : Any]]()
                            let updatedValue: [String:Any] = [

                                "data": dateString,
                                "is_read": false,
                                "message": content
                               
                            ]
                            
                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
                                var targetConversation: [String:Any]?
                                var position = 0
                                
                                for userConversation in otherUserConversations {
                                    if let currentId = userConversation["id"] as? String, currentId == conversation {
                                        targetConversation = userConversation
                                        break
                                        }
                                    position += 1
                                }
                                
                                if var targetConversation = targetConversation {
                                    targetConversation["latest_message"] = updatedValue
                                    otherUserConversations[position] = targetConversation
                                    databaseEntryConversations = otherUserConversations
                                    
                                }
                                
                                else {
                                    //failed to find in current collection
                                    let newConversationData: [String: Any] = [
                                        "id" : conversation,
                                        "other_user_id": currentId,
                                        "name": currentName,
                                        "latest_message": updatedValue
                                    ]
                                    otherUserConversations.append(newConversationData)
                                    databaseEntryConversations = otherUserConversations
                                    
                                }
                            }
                            
                            else {
                                // current collection does not exist
                                let newConversationData: [String: Any] = [
                                    "id" : conversation,
                                    "other_user_id": currentUserId,
                                    "name": currentName,
                                    "latest_message": updatedValue
                                ]
                                databaseEntryConversations = [
                                    newConversationData
                                ]
                            }
                        
                            strongSelf.database.child("users/\(otherUserId)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                                    guard error == nil else {
                                        completion(false)
                                        return
                                    }
                                    
                                    
                                    completion(true)
                                })
                            })
                    })
                })
            }
        })
    }
}

extension StorageService {
    
    public typealias UploadPictureCompletion = (Result<String,Error>) -> Void
    /// upload image that will be sent in a conversation message
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        Ref().storageRoot.child("message_images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                print("failed to upload data to firebase")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            Ref().storageRoot.child("message_images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    //
    public func uploadMessageVideo(with fileURL: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        Ref().storageRoot.child("message_videos/\(fileName)").putFile(from: fileURL, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                print("failed to upload video to firebase")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            Ref().storageRoot.child("message_videos/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL,Error>) -> Void ) {
        let reference = Ref().storageRoot.child(path)
        
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            completion(.success(url))
        })
    }
    
    
    public func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        print("Deleting conversation with id: \(conversationId)")
        
        // Get all conversations for current user
        //delete conversation with target id
        // reset those conversations for the user in database
        let ref = database.child("users/\(userId)/conversations")
        ref.observeSingleEvent(of: .value, with: {snapshot in
            if var conversations = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for conversation in conversations {
                    if let id = conversation["id"] as? String,
                       id == conversationId {
                        print("found conversation to delete")
                        break
                    }
                    positionToRemove += 1
                    
                }
                
                conversations.remove(at: positionToRemove)
                ref.setValue(conversations, withCompletionBlock:  {error, _ in
                    guard error == nil else {
                        completion(false)
                        print("failed to cancel conversation")
                        return
                    }
                    print("deleted conversation")
                    completion(true)
                })
            }
            
        })
        
    }
    
 
    public func conversationExists(with targetRecipientId: String, completion: @escaping (Result<String, Error>) ->Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        database.child("users/\(targetRecipientId)/conversations").observeSingleEvent(of: .value, with: {snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseErrors.failedToFetch))
                return
            }
            
            if let conversation = collection.first(where: {
                guard let targetSenderId = $0["other_user_id"] as? String else {
                    return false
                }
                return userID == targetSenderId
            }) {
                //get id
                guard let id = conversation["id"] as? String else {
                    completion(.failure(DatabaseErrors.failedToFetch))
                    return
                }
                completion(.success(id))
                return
            }
            
            completion(.failure(DatabaseErrors.failedToFetch))
            return
            
        })
    
    }
    
    public enum DatabaseErrors: Error {
        case failedToFetch
        case failedToGetDownloadURL
    }
}

