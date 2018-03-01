//
//  ChatController.swift
//  Noir
//
//  Created by Lynx on 2/21/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
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
        
        picker.delegate = self
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        
        setupInput()
        
        if PFUser.current()?["membership"] as! String == "basic" {
            
            if imagesSent == 5 {
//                self.inputToolbar.contentView.leftBarButtonItem = nil
                
                dialogueBox(title: "SEND UNLIMITED IMAGES!!", messageText: "Paid Monthly Members are able to send unlimited images via chat to other members! Free Members are limited in how many images they can send. Visit the Shop to get your membership and start sending images!")
            }
            
        } else {
            //put something in here if I feel like it
        }
        
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
        
        let mediaButton = UIButton(type: .roundedRect)
        mediaButton.setImage(UIImage(named: "photo-7"), for: .normal)
        mediaButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sendButton)
        view.addSubview(mediaButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        mediaButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        mediaButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        mediaButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        mediaButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        mediaButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
       
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: mediaButton.rightAnchor, constant: 8).isActive = true
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
        
        if inputTextField.text != nil && inputTextField.text != "" {
            sendMessage(senderID: (PFUser.current()?.objectId)!, senderName: (PFUser.current()?.username)!, toUser: (member?.memberID)!, toUserName: (member?.memberName)!, text: inputTextField.text!)
            
            print(inputTextField.text)
        }
        
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

func sendMessage(senderID: String, senderName: String, toUser: String, toUserName: String, text: String) {
    
    let chat = PFObject(className: "Chat")
    
    chat["senderID"] = senderID
    chat["senderName"] = senderName
    chat["text"] = text
    chat["url"] = ""
    chat["toUser"] = toUser
    chat["toUserName"] = toUserName
    chat["messageRead"] = false
//    chat["chatID"] = chatID
    chat["app"] = APPLICATION
    
    var installationID = PFInstallation()
    do {
        let user = try PFQuery.getUserObject(withId: displayedUserID)
        
        if user["installation"] != nil {
            installationID = (user["installation"] as? PFInstallation)!
        }
        
    }catch{
        print("No User Selected")
    }
    
    
    
    PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["recipientId": toUser, "chatmessage": "New message from \(PFUser.current()!.username!)", "installationID": installationID.objectId as Any], block: { (object: Any?, error: Error?) in
        
        if error != nil {
            print(error!)
            print("Push Not Successful")
        } else {
            print("PFCloud push was successful")
        }
        
    })
    
    //let chatData : Dictionary<String, Any> = ["senderId": senderID, "senderName": senderName, "text": text]
    
    chat.saveInBackground { (success, error) in
        
        if error != nil {
            print(error!)
        } else {
            //scroll to bottom
            
        }
        
    }
    
}

func sendMedia(image: PFFile?, senderID: String, senderName: String, toUser: String, toUserName: String, text: String?){
    
    if image != nil {
        let chat = PFObject(className: "Chat")
        
        chat["media"] = image
        chat["senderID"] = senderID
        chat["senderName"] = senderName
        chat["toUser"] = toUser
        chat["toUserName"] = toUserName
//        chat["chatID"] = chatID
        chat["app"] = APPLICATION
        
        var installationID = PFInstallation()
        do {
            let user = try PFQuery.getUserObject(withId: toUser)
            
            if user["installation"] != nil {
                installationID = (user["installation"] as? PFInstallation)!
            }
            
        }catch{
            print("No User Selected")
        }
        
        PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["recipientId": toUser, "chatmessage": "New message from \(PFUser.current()!.username!)", "installationID": installationID.objectId as Any], block: { (object: Any?, error: Error?) in
            
            if error != nil {
                print(error!)
                print("Push Not Successful")
            } else {
                print("PFCloud push was successful")
            }
            
        })
        
        
        chat.saveInBackground { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                //self.sendMessage(senderID: senderID, senderName: senderName, toUser: toUser, toUserName: toUserName, text: "Image sent")
                
                //scroll to bottom
                
            }
            
        }
    } else {
        
        if let inputText = text {
          sendMessage(senderID: senderID, senderName: senderName, toUser: toUser, toUserName: toUserName, text: inputText)
        } else {
          print("There was an error sending the message")
        }
        
    }
    
    //self.collectionView.reloadData()
    
}

class ChatMessageCell: BaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .blue
        
    }
    
    
    
    
}
