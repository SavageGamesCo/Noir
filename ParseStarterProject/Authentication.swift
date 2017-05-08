//
//  Authentication.swift
//  Noir
//
//  Created by Lynx on 5/8/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Address, please a real email address"
    static let WRONG_PASSWORD = "Wrong password, please enter the correct password"
    static let PROBLEM_CONNECTING = "Problem Connecting to Database"
    static let USER_NOT_FOUND = "User not found, please sign up!"
    static let EMAIL_ALREADY_IN_USE = "Email already in use, please use a different email address."
    static let WEAK_PASSWORD = "Password should be at least 6 characters long"
    
    static let DEFAULT = "There was a problem connecting to Noir."
    
}


class Authentication {

    private static let _instance = Authentication()
    
    var username = ""
    
    static var Instance: Authentication {
        
        return _instance
    }
    
    func login(withEmail: String, withPassword: String, loginHandler: LoginHandler?) {
        
        FIRAuth.auth()?.signIn(withEmail: withEmail, password: withPassword, completion: { (user, error) in
            
            
            if error != nil {
                
               self.handleErrors(err: error! as NSError, loginHandler: loginHandler)
                
            } else {
                
                loginHandler?(nil)
                
                
            }
            
        })
        
    }//Login function End
    
    
    func signUp(withUsername: String, withEmail: String, withPassword: String, signUpHandler: LoginHandler?) {
        
        FIRAuth.auth()?.createUser(withEmail: withEmail, password: withPassword, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error! as NSError, loginHandler: signUpHandler)
            } else {
                
                if user?.uid != nil {
                    
                    //Store User to the database
                    Database.Instance.saveUser(withID: user!.uid, email: withEmail, password: withPassword, username: withUsername)
                    //Setup User Defaults
                    
                    //Login
                    self.login(withEmail: withEmail, withPassword: withPassword, loginHandler: signUpHandler)
                    
                
                }
                
            }
            
        })
        
    }//Sign Up Function end
    
    func isLoggedIn() -> Bool {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            return true
        }
    
    return false
        
    }
    
    func logout() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do{
                try FIRAuth.auth()?.signOut()
                
                return true
            }catch{
                return false
            }
        }
        
        return true
    }//end lgout
    
    func userID() -> String {
        return FIRAuth.auth()!.currentUser!.uid
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?){
        
        if let errCode = FIRAuthErrorCode(rawValue: err.code) {
            switch errCode {
            case .errorCodeInvalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
            case .errorCodeWrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
            case .errorCodeUserNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
            case .errorCodeWeakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
            case .errorCodeNetworkError:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
            default:
                loginHandler?(LoginErrorCode.DEFAULT)
                break
            }
        }
        
    }
    
    
}//class
