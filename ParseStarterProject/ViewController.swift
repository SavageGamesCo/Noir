/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

var currentUser = PFUser.current()!.username

class ViewController: UIViewController {
    
    var signUpMode = false
    
    var firstrun = Bool()
    
    var activityIndicater = UIActivityIndicatorView()
    
    @IBOutlet var modeMessage: UILabel!
    
    @IBOutlet var signUpUsernameTextField: UITextField!
    
    @IBOutlet var signUpModeEmailTextField: UITextField!
    
    @IBOutlet var signUpModePasswordTextField: UITextField!
    
    @IBOutlet var signUpModeVerifyPasswordTextField: UITextField!
    
    @IBOutlet var logInModeGreeting: UILabel!

    @IBOutlet var logInModeEmailTextField: UITextField!
    
    @IBOutlet var logInModePasswordTextField: UITextField!
    
    @IBOutlet var loginOrSignup: UIButton!
    
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var logoBig: UIImageView!
    
    @IBOutlet var tagline: UILabel!
    
    @IBAction func loginOrSignup(_ sender: Any) {
        if signUpMode {
            
            LoginMode()
            
            signUpMode = false
            
            
        } else {
            
            SignUpMode()
            
            signUpMode = true
            
            
        }
    }

    @IBAction func submitButton(_ sender: Any) {
        if signUpMode {
            //sign Up
            if signUpUsernameTextField.text == "" || signUpModePasswordTextField.text == "" || signUpModeEmailTextField.text == "" || signUpModeVerifyPasswordTextField.text == "" && signUpModeVerifyPasswordTextField.text != signUpModePasswordTextField.text {
                
                dialogueBox(title: "Login Error", messageText: "Please enter you email address and password. Be sure your password matches for verification")
                
            } else {
                
                activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                activityIndicater.center = self.view.center
                activityIndicater.hidesWhenStopped = true
                activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                
                view.addSubview(activityIndicater)
                activityIndicater.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let user = PFUser()
            
                user.username = signUpUsernameTextField.text
                user.email = signUpModeEmailTextField.text
                user.password = signUpModePasswordTextField.text
            
                user.signUpInBackground(block: { (success, error) in
                
                    self.activityIndicater.stopAnimating()
                
                    UIApplication.shared.endIgnoringInteractionEvents()
                
                    if error != nil {
                    
                        var displayErrorMessage = "Something went wrong"
                    
                        if let errorMessage = error?.localizedDescription {
                            displayErrorMessage = errorMessage
                        }
                    
                        self.dialogueBox(title: "Error", messageText: displayErrorMessage)
                    } else {
                        print("user signed up")
                    
                        self.performSegue(withIdentifier: "updateProfile", sender: self)
                    }
                
                })
            }
        } else {
            //login mode
            if logInModeEmailTextField.text! == "" || logInModePasswordTextField.text! == ""  {
                
                dialogueBox(title: "Login Error", messageText: "Please enter you email address and password.")
                
            } else {
                
                activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                activityIndicater.center = self.view.center
                activityIndicater.hidesWhenStopped = true
                activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                
                view.addSubview(activityIndicater)
                activityIndicater.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
            
                PFUser.logInWithUsername(inBackground: logInModeEmailTextField.text!, password: logInModePasswordTextField.text!, block: { (user, error) in
                
                    self.activityIndicater.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                
                    if error != nil {
                        var displayErrorMessage = "Something went wrong"
                    
                        if let errorMessage = error?.localizedDescription {
                            displayErrorMessage = errorMessage
                        }
                    
                        self.dialogueBox(title: "Log In Error", messageText: displayErrorMessage)
                    } else {
                        print("logged in")
                        self.performSegue(withIdentifier: "updateProfile", sender: self)
                    }
                
                })
            }
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if signUpMode {
            SignUpMode()
            
        } else {
           LoginMode()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if signUpMode {
            SignUpMode()
            
        } else {
            LoginMode()
        }
        if currentUser != nil {
            //performSegue(withIdentifier: "ShowUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func LoginMode(){
        logInModeGreeting.isHidden = false
        logInModeEmailTextField.isHidden = false
        logInModePasswordTextField.isHidden = false
        logoBig.isHidden = false
        tagline.isHidden = false
        
        signUpUsernameTextField.isHidden = true
        signUpModeEmailTextField.isHidden = true
        signUpModePasswordTextField.isHidden = true
        signUpModeVerifyPasswordTextField.isHidden = true
        
        modeMessage.text = "Don't have an account?"
        
        loginOrSignup.setTitle("Sign Up", for: [])
        
        submitButton.setTitle("Log In", for: [])
    }
    
    func SignUpMode(){
        logInModeGreeting.isHidden = true
        logInModeEmailTextField.isHidden = true
        logInModePasswordTextField.isHidden = true
        logoBig.isHidden = true
        tagline.isHidden = true
        
        signUpUsernameTextField.isHidden = false
        signUpModeEmailTextField.isHidden = false
        signUpModePasswordTextField.isHidden = false
        signUpModeVerifyPasswordTextField.isHidden = false
        
        modeMessage.text = "Already have an account?"
        
        loginOrSignup.setTitle("Log In", for: [])
        
        submitButton.setTitle("Sign Up", for: [])
    }
    
    
    func dialogueBox(title:String, messageText:String ){
        let dialog = UIAlertController(title: title,
                                       message: messageText,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(defaultAction)
        // Present the dialog.
        
        self.present(dialog,
                     animated: true,
                     completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
