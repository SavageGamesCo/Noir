//
//  LoginExtensions.swift
//  Noir
//
//  Created by Lynx on 2/10/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

extension LoginController {
    
    //Account Functions
    
    func loginUser() {
        
        if usernameTextField.text! == "" || passwordTextField.text! == ""  {
            
            dialogueBox(title: Constants.Text.TITLE_LOGIN_ERROR, messageText: Constants.Text.ERROR_BLANK_PASSWORD)
            
        } else {
            //TODO Regex to ensure username and password uses the correct types of characters
            if (usernameTextField.text?.count)! > 30 || (passwordTextField.text?.count)! > 30 {
                
                dialogueBox(title: Constants.Text.TITLE_LOGIN_ERROR, messageText: Constants.Text.ERROR_INVALID_CREDENTIALS_LENGTH)
                
            } else {
                
                activitySpinner()
                
                userLoginValidation()
            }
        }
        
    }
    
    func logout() {
        if PFUser.current()?["online"] as! Bool == true {
            
            PFUser.current()?["online"] = false
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                if error != nil {
                    print(error!)
                } else {
                    PFUser.logOut()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func signUpUser() {
        
        if usernameTextField.text == "" || passwordTextField.text == "" || emailAddressTextField.text == "" || passwordRepeatTextField.text == "" || passwordRepeatTextField.text != passwordTextField.text {
            
            dialogueBox(title: Constants.Text.TITLE_LOGIN_ERROR, messageText: Constants.Text.ERROR_REGISTER_USER_FIELD_BLANK)
            
            
        } else {
            
            if (usernameTextField.text?.count)! > 30 || (passwordTextField.text?.count)! > 30 || (emailAddressTextField.text?.count)! > 80 || (passwordRepeatTextField.text?.count)! > 30 || passwordRepeatTextField.text != passwordTextField.text {
                
                dialogueBox(title: Constants.Text.TITLE_LOGIN_ERROR, messageText: Constants.Text.ERROR_REGISTER_CREDENTIALS_LENGTH)
                
                
            } else {
                
                activitySpinner()
                
                userDefaultsSignup()
                
            }
        }
    }
    
    fileprivate func userLoginValidation() {
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
            
            self.activityIndicater.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                var displayErrorMessage = Constants.Text.ERROR_GENERIC_LOGIN_FAILED
                
                if let errorMessage = error?.localizedDescription {
                    displayErrorMessage = errorMessage
                }
                
                self.dialogueBox(title: Constants.Text.TITLE_LOGIN_ERROR, messageText: displayErrorMessage)
            } else {
                
                if PFUser.current() != nil {
                    
                    PFUser.current()?["online"] = true
                    
                    if PFUser.current()?["echo"] != nil {
                        
                    } else {
                        PFUser.current()?["echo"] = true
                        
                    }
                    
                    PFUser.current()?.saveInBackground()
                    
                    let installation: PFInstallation = PFInstallation.current()!
                    installation["user"] = PFUser.current()
                    installation.saveInBackground()
                    
                    PFUser.current()?["installation"] = installation
                    PFUser.current()?.saveInBackground()
                    
                    let layout = UICollectionViewFlowLayout()
                    let mainViewController = MainViewController(collectionViewLayout: layout)
                    
                    self.navigationController?.pushViewController(mainViewController, animated: true)
                    
                    if let user = PFUser.current()?.email {
                        
                    }
                    
                } else {
                    self.dialogueBox(title: Constants.Text.TITLE_USER_PROFILE_ERROR, messageText: Constants.Text.ERROR_USER_PROFILE_LOAD_FAILED)
                }
            }
            
        })
    }
    
    fileprivate func userDefaultsSignup() {
        let user = PFUser()
        //Reminder parse has it's own verification for email addresses
        user.username = usernameTextField.text
        user.email = emailAddressTextField.text
        user.password = passwordTextField.text
        
        //Setup default profile image
        let defImage: UIImageView = {
            
            let image = UIImageView()
            image.image = UIImage(named: "default_user_image")
            
            return image
        }()
        
        let mainPhotoImageData = UIImageJPEGRepresentation(defImage.image!, 0.8)
        
        //Setup user defaults
        user["mainPhoto"] = PFFile(name: "mainProfile.jpg", data: mainPhotoImageData!)
        user["memberImageOne"] = PFFile(name: "mainProfile.jpg", data: mainPhotoImageData!)
        user["memberImageTwo"] = PFFile(name: "mainProfile.jpg", data: mainPhotoImageData!)
        user["memberImageThree"] = PFFile(name: "mainProfile.jpg", data: mainPhotoImageData!)
        user["memberImageFour"] = PFFile(name: "mainProfile.jpg", data: mainPhotoImageData!)
        user["age"] = Constants.ProfileDefaults.PROFILE_QUESTION_DEFAULT
        user["height"] = Constants.ProfileDefaults.PROFILE_QUESTION_DEFAULT
        user["weight"] = Constants.ProfileDefaults.PROFILE_QUESTION_DEFAULT
        user["marital"] = Constants.ProfileDefaults.PROFILE_QUESTION_DEFAULT
        user["about"] = Constants.ProfileDefaults.PROFILE_QUESTION_DEFAULT
        user["ethnicity"] = Constants.ProfileDefaults.PROFILE_QUESTION_DEFAULT
        user["body"] = Constants.ProfileDefaults.PROFILE_QUESTION_DEFAULT
        user["gender"] = Constants.ProfileDefaults.PROFILE_GENDER_DEFAULT
        user["withinDistance"] = Constants.ProfileDefaults.PROFILE_WITHIN_DISTANCE_DEFAULT
        user["localLimit"] = Constants.ProfileDefaults.PROFILE_LOCAL_LIMIT_DEFAULT
        user["globalLimit"] = Constants.ProfileDefaults.PROFILE_GLOBAL_LIMIT_DEFAULT
        user["flirtLimit"] = Constants.ProfileDefaults.PROFILE_FLIRT_LIMIT_DEFAULT
        user["flirtCount"] = Constants.ProfileDefaults.PROFILE_FLIRT_COUNT
        user["favoriteLimit"] = Constants.ProfileDefaults.PROFILE_FAVORITE_LIMIT
        user["favoriteCount"] = Constants.ProfileDefaults.PROFILE_FAVORITE_COUNT
        user["membership"] = Constants.ProfileDefaults.PROFILE_MEMBERSHIP_DEFAULT
        user["adFree"] = Constants.ProfileDefaults.PROFILE_AD_FREE_DEFAULT
        user["online"] = Constants.ProfileDefaults.PROFILE_ONLINE_DEFAULT
        user["app"] = Constants.ProfileDefaults.PROFILE_APP_DEFAULT
        user["favorites"] = Constants.ProfileDefaults.PROFILE_FAVORITES_DEFAULT
        user["flirt"] = Constants.ProfileDefaults.PROFILE_FLIRT_DEFAULT
        user["blocked"] = Constants.ProfileDefaults.PROFILE_BLOCKED_DEFAULT
        user["echo"] = Constants.ProfileDefaults.PROFILE_ECHO_DEFAULT
        
        user.signUpInBackground(block: { (success, error) in
            
            self.activityIndicater.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                var displayErrorMessage = Constants.Text.ERROR_GENERIC
                
                if let errorMessage = error?.localizedDescription {
                    displayErrorMessage = errorMessage
                }
                
                self.dialogueBox(title: Constants.Text.TITLE_ERROR, messageText: displayErrorMessage)
            } else {
                
                let installation: PFInstallation = PFInstallation.current()!
                installation["user"] = PFUser.current()
                installation.saveInBackground()
                
                PFUser.current()?["online"] = true
                PFUser.current()?["installation"] = installation
                PFUser.current()?.saveInBackground()
                
                let layout = UICollectionViewFlowLayout()
                let mainViewController = MainViewController(collectionViewLayout: layout)
                self.navigationController?.pushViewController(mainViewController, animated: true)
                
            }
            
        })
    }
    
    
    //Utility Functions
    func activitySpinner(){
        
        activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicater.center = self.view.center
        activityIndicater.hidesWhenStopped = true
        activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicater)
        activityIndicater.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func resetDialogueBox(title:String, messageText:String ){
        let dialog = UIAlertController(title: title,
                                       message: messageText,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "Submit", style: .default, handler: {
            alert -> Void in
            
            let emailTextField = dialog.textFields![0] as UITextField
            
            PFUser.requestPasswordResetForEmail(inBackground: emailTextField.text!)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        dialog.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Email Address"
        }
        
        dialog.addAction(defaultAction)
        dialog.addAction(cancelAction)
        
        self.present(dialog,
                     animated: true,
                     completion: nil)
    }

}
