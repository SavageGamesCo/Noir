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
import AVKit
import MobileCoreServices
import Photos

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    private var subscription: Subscription<PFObject>!
    
    let cellID = "cellID"
    
    var memberID = String()
    var memberName = String()
    
    lazy var inputTextField: UITextField = {
        let inputField = UITextField()
        inputField.placeholder = "Enter message..."
        inputField.borderStyle = .roundedRect
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.delegate = self
        
        return inputField
    }()
    var sender: Sender? {
        didSet{
            
            let navbar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
            view.addSubview(navbar)
            navbar.isTranslucent = false
            let navTitle = UINavigationItem()
            navTitle.title = sender?.name
            let dismissButton = UIBarButtonItem(title: "Close", style: .plain, target: nil, action: #selector(handleDismiss))
            dismissButton.tintColor = Constants.Colors.NOIR_TINT
            navTitle.rightBarButtonItem = dismissButton
            
            navbar.setItems([navTitle], animated: true)
            
            self.memberID = (sender?.userID)!
            self.memberName = (sender?.name)!
            
        }
    }
    
    var member: Member? {
        didSet{
            
            let navbar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
            view.addSubview(navbar)
            navbar.isTranslucent = false
            let navTitle = UINavigationItem()
            navTitle.title = member?.memberName
            let dismissButton = UIBarButtonItem(title: "Close", style: .plain, target: nil, action: #selector(handleDismiss))
            navTitle.rightBarButtonItem = dismissButton
            navTitle.rightBarButtonItem?.tintColor = Constants.Colors.NOIR_TINT
            navbar.setItems([navTitle], animated: true)
            self.memberID = (member?.memberID)!
            self.memberName = (member?.memberName)!
        
            
            
        }
    }
    var chatMessages = [Message()]
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        
        picker.delegate = self
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 50, left: 0, bottom: 50, right: 0)
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        
        
        
        setupInput()
        
        if PFUser.current()?["membership"] as! String == "basic" {
            //set limits on basic users
            
        } else {
            //put something in here if I feel like it
        }
        
        observeMessages()
    
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        observeMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setupMessages(){
        chatMessages.removeAll()
        let query1 = PFQuery(className: "Chat")
        let query2 = PFQuery(className: "Chat")
        
        query1.whereKey("app", equalTo: APPLICATION).whereKey("chatID", equalTo: CURRENT_USER! + memberID)
        query2.whereKey("app", equalTo: APPLICATION).whereKey("chatID", equalTo: memberID + CURRENT_USER!)
        
        let query3 : PFQuery = PFQuery.orQuery(withSubqueries: [query1,query2])
        query3.limit = 9000
        
        query3.order(byAscending: "createdAt")
        
        
        query3.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error!)
            } else if let messages = objects {
                
                if messages.count > 0 {
                    
                    
                    for message in messages {
                        let NewMessage = Message()
                        NewMessage.date = message.createdAt
                        NewMessage.messageID = message["chatID"] as? String
                        NewMessage.fromID = message["senderID"] as? String
                        NewMessage.toID = message["toUser"] as? String
                        
                        
                        if message["media"] != nil {
                            let imageFile = message["media"] as! PFFile
                            imageFile.getDataInBackground(block: { (data, error) in
                                if let imageData = data {
                                    let image = UIImage(data: imageData)
                                    NewMessage.mediaMessage = image
                                }
                                
                            })
                            
                        } else {
                            NewMessage.text = message["text"] as? String
                        }
                        
                        self.chatMessages.append(NewMessage)
                        
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
                        let lastItemIndex = IndexPath(item: item, section: 0)
                        
                        self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
                    }
                    
                    
                }
                
            }

        }
        
    }
    
    func observeMessages() {
        
        //subscribe to messages of event type
        setupMessages()
        let msgQuery = PFQuery(className: "Chat")
        
        msgQuery.whereKey("app", equalTo: APPLICATION).whereKey("chatID", contains: CURRENT_USER!)
        
        self.subscription = self.liveQueryClient.subscribe(msgQuery).handleEvent{ _, message in
            
            let query1 = PFQuery(className: "Chat")
            let query2 = PFQuery(className: "Chat")
            
            query1.whereKey("app", equalTo: APPLICATION).whereKey("chatID", equalTo: CURRENT_USER! + self.memberID)
            query2.whereKey("app", equalTo: APPLICATION).whereKey("chatID", equalTo: self.memberID + CURRENT_USER!)
            
            let query3 : PFQuery = PFQuery.orQuery(withSubqueries: [query1,query2])
            query3.limit = 2000
            
            query3.order(byDescending: "createdAt")
            
            query3.findObjectsInBackground(block: { (chatMessages, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let cMessages = chatMessages {
                        if let cMessage = cMessages.first {
                            print(cMessage)
                            let NewMessage = Message()
                            let member = Sender()
                            NewMessage.date = cMessage.createdAt
                            NewMessage.messageID = cMessage["chatID"] as? String
                            NewMessage.fromID = cMessage["senderID"] as? String
                            NewMessage.toID = cMessage["toUser"] as? String
                            NewMessage.text = cMessage["text"] as? String
                            NewMessage.sender = member
                            NewMessage.sender?.userID = cMessage["senderID"] as? String
                            
                            if cMessage["media"] != nil {
                                let imageFile = cMessage["media"] as! PFFile
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data {
                                        let image = UIImage(data: imageData)
                                        NewMessage.mediaMessage = image
                                    }
                                    
                                })
                                
                            } else {
                                NewMessage.text = cMessage["text"] as? String
                            }
                            
                            self.chatMessages.append(NewMessage)
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                                let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
                                let lastItemIndex = IndexPath(item: item, section: 0)
                                
                                self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
                            }
                            
                        }
                        
                    }
                }
               
            })
            
        }
        
    }
    
    func setupInput(){
        
        let containerView = UIView()
        containerView.backgroundColor = Constants.Colors.NOIR_WHITE
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.tintColor = Constants.Colors.NOIR_TINT
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let mediaButton = UIButton(type: .roundedRect)
        mediaButton.setImage(UIImage(named: "photo-7"), for: .normal)
        mediaButton.tintColor = Constants.Colors.NOIR_TINT
        mediaButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sendButton)
        view.addSubview(mediaButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        mediaButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        mediaButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        mediaButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mediaButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        mediaButton.addTarget(self, action: #selector(handleMedia), for: .touchUpInside)
        
       
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
    
    @objc func handleMedia(){
        let alert = UIAlertController(title: "Send Media", message: "Select A Photo", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Photos", style: .default, handler: { (alert: UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeImage)
            
        })
        
        alert.addAction(photos)
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
    }
    
    private func chooseMedia(type: CFString){
        picker.mediaTypes = [type as String]
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation( pic, 0.5)
            
            let image = PFFile(name: "chatImage.jpg", data: imageData!)
            
            sendMedia(image: image, senderID: (PFUser.current()?.objectId)!, senderName: (PFUser.current()?.username)!, toUser: self.memberID, toUserName: self.memberName)
            
            if PFUser.current()?["membership"] as! String == "basic" {
                
                if imagesSent < 5 {
                    imagesSent += 1
                }
            }
            
            
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func handleSend(){
        
        if inputTextField.text != nil && inputTextField.text != "" {
            sendMessage(senderID: (PFUser.current()?.objectId)!, senderName: (PFUser.current()?.username)!, toUser: self.memberID, toUserName: self.memberName, text: inputTextField.text!)
            inputTextField.text = ""
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        return chatMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatCell
        
        let message = chatMessages[indexPath.item]
            
        cell.message = message
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfContent = view.frame.width
        // x is the width of the logo in the left
        
        let size = CGSize(width: approximateWidthOfContent, height: 1000)
        
        //1000 is the large arbitrary values which should be taken in case of very high amount of content
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        if chatMessages[indexPath.item].text != nil {
            let estimatedFrame = NSString(string: chatMessages[indexPath.item].text!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 30)
        } else if chatMessages[indexPath.item].mediaMessage != nil{
            let estimatedFrame = chatMessages[indexPath.item].mediaMessage?.size.height
            
            return CGSize(width: view.frame.width, height: 300)
        }
       return CGSize(width: view.frame.width, height: 300)
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
        chat["chatID"] = toUser + senderID
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
        
        //let chatData : Dictionary<String, Any> = ["senderId": senderID, "senderName": senderName, "text": text]
        
        chat.saveInBackground { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                
            }
            
        }
        
    }
    
    func sendMedia(image: PFFile?, senderID: String, senderName: String, toUser: String, toUserName: String){
        
        if image != nil {
            let chat = PFObject(className: "Chat")
            
            chat["media"] = image
            chat["senderID"] = senderID
            chat["senderName"] = senderName
            chat["toUser"] = toUser
            chat["toUserName"] = toUserName
            chat["chatID"] = toUser + senderID
            chat["app"] = APPLICATION
            
            var installationID = PFInstallation()
            do {
                let user = try PFQuery.getUserObject(withId: toUser)
                
                if user["installation"] != nil {
                    installationID = (user["installation"] as? PFInstallation)!
                    
                    PFCloud.callFunction(inBackground: "sendPushToUser", withParameters: ["recipientId": toUser, "chatmessage": "New message from \(PFUser.current()!.username!)", "installationID": installationID.objectId as Any], block: { (object: Any?, error: Error?) in
                        
                        if error != nil {
                            print(error!)
                            print("Push Not Successful")
                        } else {
                            print("PFCloud push was successful")
                        }
                        
                    })
                    
                    
                }
                
                
            }catch{
                print("No User Selected")
            }
            
            chat.saveInBackground { (success, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    
                    //self.sendMessage(senderID: senderID, senderName: senderName, toUser: toUser, toUserName: toUserName, text: "Image sent")
                    
                    //scroll to bottom
                    
                }
                
            }
            
        } else {
            
            print("There was an error sending the message")
            
        }
        
        //self.collectionView.reloadData()
        
    }
    
    

}

func checkPermission() {
    let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    switch photoAuthorizationStatus {
    case .authorized:
        print("Access is granted by user")
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            print("status is \(newStatus)")
            if newStatus ==  PHAuthorizationStatus.authorized {
                /* do stuff here */
                print("success")
            }
        })
        print("It is not determined until now")
    case .restricted:
        // same same
        print("User do not have access to photo album.")
    case .denied:
        // same same
        print("User has denied the permission.")
    }
}



class ChatMessageCell: BaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .blue
        
    }
    
    
    
    
}
