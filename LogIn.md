# Log in logic
The log-in .swift files are all contained in the Sign-in/ folder, though most of the authentification logic is written precisely in two files: UserApi.swift and AppDelegate.swift ( I also created Struct Api, var User in Api.swift file)

## Welcome scene
Welcome scene is Sign-in/ViewController.swift, all I did here is give a choice between signin up or in. The UI is separated from the main code and you will find it in the Sign-in/ViewController+UI.swift file

## Sign-in
For the sign-in, check Sign-In/SignInViewController.swift (* the UI is in Sign-In/SignInViewController.swift+UI *). Once the button sign-in is tapped I do two things (* also in the Sign-In/SignInViewController.swift+UI *):
### 1. ValidateFields:
Check that email and password text fields are not empty
### 2. Sign In:
Calls Api.User.signIn() method that: uses FirebaseAuth module to authenticate, the logic is written in the UserApi.swift, if success I print the user uid and move to the home page
If unsuccessful I print the error. AppDelegate.swift takes care of keeping the user logged in in the method AppDelegate.configureInitialViewController()

## Sign-Up
Signin up is done in the Sign-In/SignUpViewController.swift (* the UI is in Sign-In/SignUpViewController+UI.swift file *).
Before anything, the user is asked to provide his location!!!
The user here is asked to: upload a profile picture, provide username, an email and a password! 
The profile picture is extracted by imagePickerController, in the extension in the Sign-In/SignUpViewController+UI.swift file.

Once he presses sign-up:
### 1. Fields are validated by method validateFields():
check that no field is empty
### 2. Sig-up method:
Calls UserApi.swift to signup with the following method
* Api.User.signUp(withUsername: self.fullNameText.text!, email: self.emailText.text!, password: self.passwordText.text!, image: self.image) *
Using FirebaseAuth createUser method, I create then a dictionary that contains all informations of the user, such as uid, email, username, profileImageUrl, gender, sizes etc..
{The sizes are not asked as of today, maybe in the future I will add the possibility of requesting sizes for better filtering of cards).
*let storageProfile = Ref().storageSpecificProfile(uid: authData.user.uid)*
Save photo in the storageProfile reference that I created here

It then gets the location of the user and sends it to the firebaseRef that I introduce in the Ref.swift file
If the user is successfully created, AppDelegate launches .configureInitialViewController() and we are sent to the homepage

## Retrieve password
Here it is very straight-forward, all logic is handled by FirebaseAuth in the UserApi.swift file



        






