//
//  LoginView.swift
//  Noir
//
//  Created by Lynx on 2/10/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

extension LoginController {
    
    func setupCopyright(){
        copyrightLine.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        copyrightLine.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        copyrightLine.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        copyrightLine.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl(){
        loginRegisterControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
    func setupLogo(){
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: loginRegisterControl.topAnchor, constant: -12).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1 ).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupRecoverPasswordButton(){
        recoverPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recoverPasswordButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        recoverPasswordButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        recoverPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupInputContainerView() {
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        
        inputContainerHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 200)
        inputContainerHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(usernameTextField)
        inputsContainerView.addSubview(emailAddressTextField)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordRepeatTextField)
        inputsContainerView.addSubview(separator)
        inputsContainerView.addSubview(separator2)
        inputsContainerView.addSubview(separator3)
        
        usernameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameTextFieldHeightanchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        usernameTextFieldHeightanchor?.isActive = true
        
        
        emailAddressTextFieldHeightAnchor = emailAddressTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        emailAddressTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailAddressTextField.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        emailAddressTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailAddressTextFieldHeightAnchor?.isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: separator2.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightanchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordTextFieldHeightanchor?.isActive = true
        
        passwordRepeatTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordRepeatTextField.topAnchor.constraint(equalTo: separator3.bottomAnchor).isActive = true
        passwordRepeatTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordRepeatTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/4)
        passwordRepeatTextFieldHeightAnchor?.isActive = true
        
        separator.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        separator2.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        separator2.topAnchor.constraint(equalTo: emailAddressTextField.bottomAnchor).isActive = true
        separator2.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        separator2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        separator3.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        separator3.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        separator3.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        separator3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        handleLoginToggle()
    }
    
    @objc func handleLoginToggle(){
        let title = loginRegisterControl.titleForSegment(at: loginRegisterControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of the input container
        inputContainerHeightAnchor?.constant = loginRegisterControl.selectedSegmentIndex == 0 ? 100 : 200
        
        //change height of email address text field
        emailAddressTextFieldHeightAnchor?.isActive = false
        emailAddressTextFieldHeightAnchor = emailAddressTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        emailAddressTextFieldHeightAnchor?.isActive = true
        
        usernameTextFieldHeightanchor?.isActive = false
        usernameTextFieldHeightanchor = usernameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        usernameTextFieldHeightanchor?.isActive = true
        
        passwordTextFieldHeightanchor?.isActive = false
        passwordTextFieldHeightanchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterControl.selectedSegmentIndex == 0 ? 1/2 : 1/4)
        passwordTextFieldHeightanchor?.isActive = true
        
        passwordRepeatTextFieldHeightAnchor?.isActive = false
        passwordRepeatTextFieldHeightAnchor = passwordRepeatTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterControl.selectedSegmentIndex == 0 ? 0 : 1/4)
        passwordRepeatTextFieldHeightAnchor?.isActive = true
        
    }
    
    
    //Keyboard Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true);
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}
