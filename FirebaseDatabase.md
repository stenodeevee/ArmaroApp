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
  saving the item
  "items": {
  
  "author" : "steno",
        "author_profile_url" : "https://firebasestorage.googleapis.com/v0/b/armaro-f5569.appspot.com/o/profile%2FswqbU9NLgeZrlM2mvcKm1BiRcd72?alt=media&token=23e0575a-e472-4a42-8a80-8809c53b97cf",
        "brand" : "NIke x Undercover",
        "conversations" : [ {
          "id" : "conversation_-MJa1bQtiTXJ9TH4MXE6_-MJa5kU_vVWY-uietTNo_Oct 16, 2020 at 2:09:44 PM GMT+2",
          "latest_message" : {
           "data" : "Oct 18, 2020 at 6:34:40 PM GMT+2",
            "is_read" : false,
           "message" : "Tuttte dc\n"
          },
         "name" : "RickyReds",
          "other_post_id" : "-MJa5kU_vVWY-uietTNo"
        }, {
          "id" : "conversation_-MJa6F5RNiOiTkMg5KGr_-MJa1bQtiTXJ9TH4MXE6_Oct 16, 2020 at 2:11:53 PM GMT+2",
          "latest_message" : {
            "data" : "Oct 18, 2020 at 6:29:31 PM GMT+2",
            "is_read" : false,
            "message" : "Oooh"
          },
          "name" : "RickyReds",
          "other_post_id" : "-MJa6F5RNiOiTkMg5KGr"
        }, {
          "id" : "conversation_-MJwUJvh-bC1UaS19rsA_-MJa1bQtiTXJ9TH4MXE6_26 Oct 2020 at 21:42:18 CET",
          "latest_message" : {
           "data" : "26 Oct 2020 at 21:42:18 CET",
           "is_read" : false,
           "message" : "Bella mi piace"
          },
          "name" : "RickyReds",
          "other_post_id" : "-MJwUJvh-bC1UaS19rsA"
        } ],
        "description" : "NIke shoes, fits narrow, good conditions",
      "gender" : "M",
      "image_url" : "https://firebasestorage.googleapis.com/v0/b/armaro-f5569.appspot.com/o/items%2FswqbU9NLgeZrlM2mvcKm1BiRcd72%2FOptional(%22-MJa1bQtiTXJ9TH4MXE6%22).jpeg?alt=media&token=f93339e2-7f62-40db-ae47-c51981143556",
      "postID" : "-MJa1bQtiTXJ9TH4MXE6",
      "size" : "45",
      "type" : "shoes",
      "userID" : "swqbU9NLgeZrlM2mvcKm1BiRcd72"
    
}

  

