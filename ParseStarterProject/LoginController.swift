//
//  LoginController.swift
//  Noir
//
//  Created by Lynx on 2/9/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import Firebase
import GoogleMobileAds
import UserNotifications


class LoginController: UIViewController {
    
    var activityIndicater = UIActivityIndicatorView()
    var inputContainerHeightAnchor: NSLayoutConstraint?
    var emailAddressTextFieldHeightAnchor: NSLayoutConstraint?
    var usernameTextFieldHeightanchor: NSLayoutConstraint?
    var passwordTextFieldHeightanchor: NSLayoutConstraint?
    var passwordRepeatTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.NOIR_WHITE
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Constants.Colors.NOIR_GREY_DARK
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Constants.Colors.NOIR_WHITE, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let recoverPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Constants.Colors.NOIR_GREY_DARK
        button.setTitle("Recover Password", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Constants.Colors.NOIR_WHITE, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleRecoverPassword), for: .touchUpInside)
        
        return button
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let emailAddressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let passwordRepeatTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Verify Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let copyrightLine: UILabel = {
        let text = UILabel()
        text.text = Constants.Text.COPYRIGHT_LINE
        text.font = UIFont.systemFont(ofSize: 12)
        text.textColor = Constants.Colors.NOIR_LIGHT_TEXT
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.NOIR_DARK_LINE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let separator2: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.NOIR_DARK_LINE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let separator3: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.NOIR_DARK_LINE
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:Constants.App.NOIR_LOGO)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = Constants.Colors.NOIR_GREY_DARK
        
        return imageView
    }()
    
    lazy var loginRegisterControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = Constants.Colors.NOIR_GREY_DARK
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 15
//        segmentedControl.layer.masksToBounds = true
        segmentedControl.addTarget(self, action: #selector(handleLoginToggle), for: .valueChanged)
        
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Constants.Colors.NOIR_GREY_LIGHT
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(recoverPasswordButton)
        view.addSubview(logoImageView)
        view.addSubview(loginRegisterControl)
        view.addSubview(copyrightLine)
        
        setupInputContainerView()
        setupLogo()
        setupLoginRegisterSegmentedControl()
        setupLoginRegisterButton()
        setupRecoverPasswordButton()
        setupCopyright()
    
    }
    
    
    @objc func handleLoginRegister(){
        //TODO transfer current registration code from 1.0 to here
        if loginRegisterControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegistration()
        }
    }
    
    @objc func handleRegistration(){
        signUpUser()
    }
    
    @objc func handleLogin(){
        loginUser()
    }
    
    @objc func handleRecoverPassword() {
        
        resetDialogueBox(title: Constants.Text.TITLE_RECOVER_PASSWORD, messageText: Constants.Text.DIALOGUE_RECOVER_PASSWORD)
        
    }
    
    
    
    
}
