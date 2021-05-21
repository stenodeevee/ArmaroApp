Welcome to ARMARO
=================

## Overview of the code:
### Core tabs:
The core views of the app are in folder NoNameApp/Core Tabs, and they are only (for now) three. 
#### 1 is the ProfileViewController, where the user can see all items he has posted, edit his profile, and upload new items.
#### 2 is ConversationsViewController, similar to all messanger apps, the user has information on all his current conversations
#### 3 is RadarViewController, where card swiping happens, similarly to Tinder. Since Tinder has patented this method, we will have to think about something a little bit different

### Sign in:
Takes you through the process of signing in, the code should be clear and apparent. For now there are 4 main views here, the welcome scene, the sign-up scene, the sign-in scene and the retrieve password. All authentification was done via Firebase, hmu Justin if you need access to the database

### Api/User/Post:
.swift files that are not regrouped into folders are simply extensions that handle some repetetive functions or introduce structs and classes like the User struct, the message struct, and the post struct.

### Other folder:
Here are secondary views, some of them are unused at this point (like otherUserProfileViewController)




updated 29/10/2020
------------------

There are some things that I would love to push, but don't have access to the code as of today (will get it tonight FYI). 
The main idea of the app is a dating/chat app, but for clothes, connected to firebase.

update 30/10/2020
-----------------

I have finally commited and pushed all changes. The code requires some factoring in certain parts, and now that I've finally started beta testing on actual devices, I think it's time to look a little bit at code performance. 


