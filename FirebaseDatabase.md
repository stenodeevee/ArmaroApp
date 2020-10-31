# ABOUT THE DATABASE
Some info about the database, I used a very flatten data structure, because I didn't want it to go too deep
## STRUCTURE
### Geolocs:
  Geolocs contains locations of each user stored under the user unique userID
  
  "geolocs": {
  
    "userID": {
      "g": geolocs.uid,
      "l": {
          0: "latitude",     
          1: "longitude"   
    }
    
  }
### conversation_currentpostID_otherpostID_date:
  I have decided to write a different node for each conversation, that way they are faster to be retrieved(?). A conversation is identified by the two posts that are having the conversation
  
  "conversation_currentpostID_otherpostID_date": {
  
    "messages": {
      "0": {
          "content": text,
          "date": date,
          "id" : unique identifier for conversation,
          "is_read": Bool,
          "name" : username of sender,
          "sender_id": identifier of sender,
          "type": text/video/photo/audio
    }
    .... other messages
    
}

### actions:
  saving the likes and dislikes for each user, it would probably be more efficient just to share the likes, but in the future we will not present the cards that are likes
  "actions": {
  
    "userID": {
      "postID": Bool (is it like or dislike)
    }
    ....
    
}

### items:
  whenever a user posts an item, we will save it in the database with several informations, such as the username of the poster, his profile image url, the photo of the item,
  the size and type + the conversations that are open between the userPost and the other users
  "items": {
  
  "postID": {
            "author" : "steno",
            "author_profile_url" : url with photo of user,
            "brand" : string,
            "conversations" : {
                              "id" : conversation id,
                              "latest_message" : {
                                                  "data" : date,
                                                  "is_read" : bool,
                                                   "message" : "text",
                                                 },
                              "name" : name of receiver,
                              "other_post_id" : id of post we are trading,
                               }
            "description" : "NIke shoes, fits narrow, good conditions",
            "gender" : "M",
            "image_url" : urlwithImage,
            "postID" : "-MJa1bQtiTXJ9TH4MXE6",
            "size" : "45",
            "type" : "shoes",
            "userID" : "swqbU9NLgeZrlM2mvcKm1BiRcd72",
            }
     .... other posts

}

### users:
  saving the user information
  "users": {
  
  "userID" : {
              "current_latitude",
              "current_longitude",
              "email",
              "gender",
              "profileimageurl",
              "sizes",
              "uid",
              "username"
              }
  
  }

  

