//
//  ChatController.swift
//  Noir
//
//  Created by Lynx on 2/21/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellID = "cellID"
    
    lazy var inputTextField: UITextField = {
        let inputField = UITextField()
        inputField.placeholder = "Enter message..."
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.delegate = self
        
        return inputField
    }()
    var sender: Sender? {
        didSet{
            
            let navbar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
            view.addSubview(navbar)
            let navTitle = UINavigationItem()
            navTitle.title = sender?.name
            let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: nil, action: #selector(handleDismiss))
            navTitle.rightBarButtonItem = dismissButton
            navbar.setItems([navTitle], animated: true)
            
        }
    }
    
    var member: Member? {
        didSet{
            
            let navbar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
            view.addSubview(navbar)
            let navTitle = UINavigationItem()
            navTitle.title = member?.memberName
            let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: nil, action: #selector(handleDismiss))
            navTitle.rightBarButtonItem = dismissButton
            navbar.setItems([navTitle], animated: true)
            
        }
    }
    var messages: [Message]?
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        
        setupInput()
        
        observeMessages()
    }
    
    func observeMessages() {
        //subscribe to messages of event type
        let message = Message()
        
        
    }
    
    func setupInput(){
        
        let containerView = UIView()
        containerView.backgroundColor = Constants.Colors.NOIR_WHITE
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
       
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let line = UIView()
        line.backgroundColor = Constants.Colors.NOIR_RECENT_MESSAGES_DIVIDER
        line.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(line)
        
        line.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    @objc func handleSend(){
        
        
        print(inputTextField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let counter = messages?.count {
            return counter
        }
        
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    

}

class ChatMessageCell: BaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .blue
        
    }
    
    
    
    
}
