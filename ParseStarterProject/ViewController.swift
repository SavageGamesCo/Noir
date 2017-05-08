/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import FirebaseAuth
import GoogleMobileAds


var displayedUserID = String()

var currentUser = ""

class ViewController: UIViewController {
    
    var signUpMode = false
    
    var firstrun = Bool()
    
    var activityIndicater = UIActivityIndicatorView()
    
    @IBOutlet var ScrollView: UIScrollView!
    
    @IBOutlet var modeMessage: UILabel!
    
    @IBOutlet var signUpUsernameTextField: UITextField!
    
    @IBOutlet var signUpModeEmailTextField: UITextField!
    
    @IBOutlet var signUpModePasswordTextField: UITextField!
    
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet var signUpModeVerifyPasswordTextField: UITextField!
    
    @IBOutlet var logInModeGreeting: UILabel!

    @IBOutlet var logInModeEmailTextField: UITextField!
    
    @IBOutlet var logInModePasswordTextField: UITextField!
    
    @IBOutlet var loginOrSignup: UIButton!
    
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var logoBig: UIImageView!
    
    @IBOutlet var tagline: UILabel!
    
    @IBOutlet weak var bannerAdView: GADBannerView!
    
    @IBAction func loginOrSignup(_ sender: Any) {
        //Check if the app is in the sign up or the login mode and switch the modes based on that
        if signUpMode {
            //switch to login mode
            LoginMode()
            
            signUpMode = false
            
            
        } else {
            //Switch to signup mode
            SignUpMode()
            
            signUpMode = true
            
            
        }
    }

    @IBAction func submitButton(_ sender: Any) {
        //Submit button has different functions based on app mode.
        if signUpMode {
            
            activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicater.center = self.view.center
            activityIndicater.hidesWhenStopped = true
            activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicater)
            activityIndicater.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            //sign Up
            if signUpUsernameTextField.text == "" || signUpModePasswordTextField.text == "" || signUpModeEmailTextField.text == "" || signUpModeVerifyPasswordTextField.text == "" || signUpModeVerifyPasswordTextField.text != signUpModePasswordTextField.text {
                
                dialogueBox(title: "Login Error", messageText: "Please enter you email address and password. Be sure your password matches for verification")
                
            } else {
                
                if (signUpUsernameTextField.text?.characters.count)! > 30 || (signUpModePasswordTextField.text?.characters.count)! > 30 || (signUpModeEmailTextField.text?.characters.count)! > 80 || (signUpModeVerifyPasswordTextField.text?.characters.count)! > 30 || signUpModeVerifyPasswordTextField.text != signUpModePasswordTextField.text {
                    
                    dialogueBox(title: "Login Error", messageText: "Please enter no more than 30 characters for your username or password. No more than 80 characters for your email address.")
                    
                } else {
                    
                    Authentication.Instance.signUp(withUsername: signUpUsernameTextField.text!, withEmail: signUpModeEmailTextField.text!, withPassword: signUpModePasswordTextField.text!, signUpHandler: { (message) in
                        
                        if message != nil {
                            self.dialogueBox(title: "New User Creation Error", messageText: message!)
                        } else {
                            print("SignUp Completed")
                            
                            self.logInModeEmailTextField.text = ""
                            self.logInModePasswordTextField.text = ""
                            
                            self.performSegue(withIdentifier: "toUserTable", sender: self)
                            
                        }
                        
                    })
                    
                }
                
                self.activityIndicater.stopAnimating()
                
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            
            
        } else {
            
            activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicater.center = self.view.center
            activityIndicater.hidesWhenStopped = true
            activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicater)
            activityIndicater.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if logInModeEmailTextField.text != "" && logInModePasswordTextField.text != "" {
                
                Authentication.Instance.login(withEmail: logInModeEmailTextField.text!, withPassword: logInModePasswordTextField.text!, loginHandler: { (message) in
                    
                    if message != nil {
                        self.dialogueBox(title: "Login Error", messageText: message!)
                    } else {
                        print("Login Completed")
                        
                        self.logInModeEmailTextField.text = ""
                        self.logInModePasswordTextField.text = ""
                        
                        self.performSegue(withIdentifier: "toUserTable", sender: self)
                    }
                    
                })
            }
            self.activityIndicater.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
        }

        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Show a view dependent on which mode is visible.
        if signUpMode {
            
            SignUpMode()
            
        } else {
            
            LoginMode()
            
        }
        
        if Authentication.Instance.isLoggedIn() {
            
            self.performSegue(withIdentifier: "toUserTable", sender: self)
            
        }
        
        

        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerAdView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerAdView.rootViewController = self
        bannerAdView.load(GADRequest())
        
        registerForKeyboardNotifications()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
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
        
        commonActionSheet(title: "Beta: What To Test", message: "Thank you for participating in the beta. During the Beta, this screen will inform you of what needs to be tested, what issues we are already aware of and feature changes.\n\n This is the first beta test. We will be testing the login process, the all user view, local user view and the database. To participate in this test please do the following: Log In, tap the globe to view all logged in users, tap the nav pin to view users within 10 miles of you, select a user, send a flirt, click the star to favorite, click the chat bubble to chat with someone. \n\n Known Issues: Chat Message order is NOT consistent.\n\n Warning: This is a Beta test, not the full end product. This is also testing the server and database. The results will determine if we change databases. This means you MAY lose conversations on the next beta update. As the test period moves forward different features will be added and you will be asked to test. This is currently a closed beta, so there will only be about 30 users initially. So you may not have any members near you yet. Hang in there!")
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
        
        commonActionSheet(title: "Terms of Use", message: "Welcome to the Noir Closed Beta. By clicking 'OK' you are agreeing to and understand the following terms of use, valid during the course of this beta test.\n\n Noir's goal is to recreate the inclusive environment of the Black nightclubs in 1920's Harlem. The Harlem Nightclubs catered to people of color but everyone was welcome. They were one of the few places where people of color were able to enter through the front door and have services tailored specifically to them. All were welcome, but everyone knew the deal. As such, racism, racist language and blatant discrimination will not be tolerated. That said, make no mistake, this is a home for gay people of color. It is a place for us to meet each other, mingle with each other and stay in touch with each other.\n\n The following rules are in Affect:\n\n No Nudity on public images.\n No Discriminatory language such as 'No, <insert race/religion/bodytype here>'.\n No Harassament.\n Please report ANY profiles that are participating in trolling, cyber bullying, cyber stalking, or discriminatory language.\n\n Otherwise, enjoy your time here on Noir, Mobile Dating for Gay People of Color.")
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true);
    }
    
    //Keyboard Methods
    
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.ScrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.ScrollView.contentInset = contentInsets
        self.ScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.signUpUsernameTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
        if let activeField = self.signUpModeEmailTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
        if let activeField = self.signUpModePasswordTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
        if let activeField = self.signUpModeVerifyPasswordTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
        if let activeField = self.logInModeEmailTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
        if let activeField = self.logInModePasswordTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.ScrollView.contentInset = contentInsets
        self.ScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.ScrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func commonActionSheet(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
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
