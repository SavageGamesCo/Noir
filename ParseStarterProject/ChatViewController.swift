//
//  ChatViewController.swift
//  
//
//  Created by Lynx on 5/3/17.
//
//

import UIKit
import Parse
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import UserNotifications
import ParseLiveQuery

private let reuseIdentifier = "Cell"

class ChatViewController: JSQMessagesViewController, MessageReceivedDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let currentUser = PFUser.current()?.objectId!
    
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    
    private var subscription: Subscription<PFObject>!
    
    // This message query filters every incoming message that is
    // On the class 'Message' and has a 'message' field
    
    private var messages = [JSQMessage]()
    private var messageIDs = [String]()
    
    var timer: Timer = Timer()
    
    var chatID = String()
    
    var avatar = UIImage()
    var senderavatar = UIImage()
    
    let picker = UIImagePickerController()
    
    let outGoingColor = UIColor(colorLiteralRed: 0.988, green: 0.685, blue: 0.000, alpha: 1.0)
    let inComingColor = UIColor(colorLiteralRed: 0.647, green: 0.647, blue: 0.647, alpha: 1.0)
    let bkgColor = UIColor(colorLiteralRed: 0.224, green: 0.224, blue: 0.223, alpha: 1.0)

    @IBOutlet var MainView: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        picker.delegate = self
        MessagesHandler.Instance.delegate = self
        
        //Set user name for the navigation controller
        do {
            let query = try PFQuery.getUserObject(withId: displayedUserID)
            self.navigationItem.title = query.username
        }catch{
            print("No User Selected")
        }
        //end set user name
        
        
        //Setup Current User
        self.senderId = PFUser.current()?.objectId
        self.senderDisplayName = PFUser.current()?.username
        
        let imageFile = PFUser.current()?["mainPhoto"] as! PFFile
        
        imageFile.getDataInBackground(block: {(data, error) in
            
            if let imageData = data {
                self.avatar = (UIImage(data: imageData)!)
                
            } else {
                self.avatar = (UIImage(named: "default_user_image.png")!)
            }
        })
        //setup of Current USer
        
        //Setup the color of the background
        self.collectionView.backgroundView?.backgroundColor = bkgColor
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        self.collectionView.collectionViewLayout.springinessEnabled = true
        
        
        //observers
        self.initMessages()
        
        self.observeMessages()
        
    }
    
    //Functions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        var toUserName = String()
        
        do{
            
        let query = try PFQuery.getUserObject(withId: displayedUserID)
        
        toUserName = query.username!
            
        } catch {
        
        }
        
        sendMessage(senderID: senderId, senderName: senderDisplayName, toUser: displayedUserID, toUserName: toUserName, text: text)
        
        collectionView.reloadData()
        
        finishSendingMessage()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
//            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ChatViewController.observeMessages), userInfo: nil, repeats: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        timer.invalidate()
    }
    
    func initMessages(){
        
        
        self.chatID = (PFUser.current()?.objectId!)! + displayedUserID
        
        let query = PFQuery(className: "Chat")
        
        query.order(byAscending: "createdAt").whereKey("app", equalTo: "noir")
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                print(error!)
            } else if let messages = objects {
                for message in messages {
                    if (message["senderID"] as? String == PFUser.current()?.objectId! && message["toUser"] as? String == displayedUserID) || (message["senderID"] as? String == displayedUserID && message["toUser"] as? String == PFUser.current()?.objectId!) {
                        if let senderID = message["senderID"] as? String {
                            if let text = message["text"] as? String {
                                if let messageID = message.objectId {
                                    if let cID = message["ChatID"] as? String {
                                        self.chatID = cID
                                    }
                                    self.chatAvatar()
                                    self.messageReceived(senderID: senderID, text: text, messageID: messageID, chatID: self.chatID)
                                    
                                    self.scrollToBottom(animated: true)
                                    
                                    self.automaticallyScrollsToMostRecentMessage = true
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        
//        let mQuery = PFQuery(className: "Chat")
//        
//        mQuery.order(byAscending: "createdAt")
//        
//        mQuery.findObjectsInBackground { (objects, error) in
//            
//            if error != nil {
//                print(error!)
//            } else if let messages = objects {
//                for message in messages {
//                    if (message["senderID"] as? String == PFUser.current()?.objectId! && message["toUser"] as? String == displayedUserID) || (message["senderID"] as? String == displayedUserID && message["toUser"] as? String == PFUser.current()?.objectId!)  {
//                        if let senderID = message["senderID"] as? String {
//                            if let media = message["media"] as? PFFile {
//                                if let messageID = message.objectId {
//                                    
//                                    self.chatAvatar()
//                                    self.mediaMessageReceived(senderID: senderID, media: media, messageID: messageID)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            
//        }
        
    }
    
    
    func observeMessages(){
        DispatchQueue.main.async {
            
            let msgQuery = PFQuery(className: "Chat")
            
            msgQuery.whereKeyExists("text")
            func queryish(){
            
            }
            
            self.subscription = self.liveQueryClient.subscribe(msgQuery).handleEvent{ _, message in
                
                let query = PFQuery(className: "Chat")
                
                query.order(byAscending: "createdAt").whereKey("app", equalTo: "noir")
                
                query.findObjectsInBackground { (objects, error) in
                    
                    if error != nil {
                        print(error!)
                    } else if let messages = objects {
                        for message in messages {
                            if (message["senderID"] as? String == PFUser.current()?.objectId! && message["toUser"] as? String == displayedUserID) || (message["senderID"] as? String == displayedUserID && message["toUser"] as? String == PFUser.current()?.objectId!) {
                                if let senderID = message["senderID"] as? String {
                                    if let text = message["text"] as? String {
                                        if let messageID = message.objectId {
                                            
                                            self.chatAvatar()
                                            self.messageReceived(senderID: senderID, text: text, messageID: messageID, chatID: self.chatID)
                                            
                                            self.scrollToBottom(animated: true)
                                            self.automaticallyScrollsToMostRecentMessage = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func observeIncomingMessages(){
        DispatchQueue.main.async {
            
            let msgQuery = PFQuery(className: "Chat")
            
            msgQuery.whereKeyExists("toUser").whereKey("app", equalTo: "noir")
            
            
            self.subscription = self.liveQueryClient.subscribe(msgQuery).handleEvent{ _, message in
            
                let query = PFQuery(className: "Chat")
                
                query.whereKey("toUser", equalTo: PFUser.current()?.objectId! as Any)
                
                query.order(byAscending: "createdAt")
                
                query.findObjectsInBackground { (objects, error) in
                    
                    if error != nil {
                        print(error!)
                    } else if let messages = objects {
                        for message in messages {
                            if message["senderID"] as? String == displayedUserID {
                                if let senderID = message["senderID"] as? String {
                                    if let text = message["text"] as? String {
                                        if let chatID = message["chatID"] as? String{
                                            if let messageID = message.objectId {
                                                
                                                self.chatAvatar()
                                                
                                                self.messageReceived(senderID: senderID, text: text, messageID: messageID, chatID: chatID)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func observeMediaMessages() {
        DispatchQueue.main.async {
            
            let msgQuery = PFQuery(className: "Chat")
            
            msgQuery.whereKeyExists("media").whereKey("app", equalTo: "noir")
            
            
            self.subscription = self.liveQueryClient.subscribe(msgQuery).handleEvent{ _, message in
            
                let query = PFQuery(className: "Chat")
                
                
                query.order(byAscending: "createdAt")
                
                query.findObjectsInBackground { (objects, error) in
                    
                    if error != nil {
                        print(error!)
                    } else if let messages = objects {
                        for message in messages {
                            if (message["senderID"] as? String == PFUser.current()?.objectId! && message["toUser"] as? String == displayedUserID) || (message["senderID"] as? String == displayedUserID && message["toUser"] as? String == PFUser.current()?.objectId!)  {
                                if let senderID = message["senderID"] as? String {
                                    if let media = message["media"] as? PFFile {
                                        if let messageID = message.objectId {
                                            
                                            self.chatAvatar()
                                            self.mediaMessageReceived(senderID: senderID, media: media, messageID: messageID)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }

            }
            
        }
        collectionView.reloadData()
    }

    func observeIncomingMediaMessages() {
        DispatchQueue.main.async {
            
            let query = PFQuery(className: "Chat")
            
            query.whereKey("toUser", equalTo: PFUser.current()?.objectId! as Any)
            
            query.order(byAscending: "createdAt").whereKey("app", equalTo: "noir")
            
            query.findObjectsInBackground { (objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let messages = objects {
                    for message in messages {
                        if message["senderID"] as? String == displayedUserID {
                            if let senderID = message["senderID"] as? String {
                                if let media = message["media"] as? PFFile {
                                    if let messageID = message.objectId {
                                        self.chatAvatar()
                                        self.mediaMessageReceived(senderID: senderID, media: media, messageID: messageID)
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alert = UIAlertController(title: "Send Media", message: "Select A Photo", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Photos", style: .default, handler: { (alert: UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeImage)
        
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeImage)
            
        })
        
        //alert.addAction(photos)
        //alert.addAction(camera)
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
//            let img = JSQPhotoMediaItem(image: pic)
            
            let imageData = UIImageJPEGRepresentation( pic, 0.5)
            
            let image = PFFile(name: "mainProfile.jpg", data: imageData!)
            
            var toUserName = String()
            
            do{
                
                let query = try PFQuery.getUserObject(withId: displayedUserID)
                
                toUserName = query.username!
                
            } catch {
                
            }
            
            sendMedia(image: image, senderID: senderId, senderName: senderDisplayName, toUser: displayedUserID, toUserName: toUserName)
//            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: img))
        
        } else if let vid = info [UIImagePickerControllerMediaURL] as? URL {
            
            let video = JSQVideoMediaItem(fileURL: vid, isReadyToPlay: true)
            
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
        
        }
        
        picker.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
        
    }
    
    //picker functions
    
    private func chooseMedia(type: CFString){
        picker.mediaTypes = [type as String]
        
        present(picker, animated: true, completion: nil)
    }
    
    //end picker functions
    
    //delegate functions
    func messageReceived(senderID: String, text: String, messageID: String, chatID: String) {
        
        if messageIDs.contains(messageID){
            collectionView.reloadData()
        
        } else {
            messageIDs.append(messageID)
            
            messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, text: text))
            
            notification(displayName: senderDisplayName)
            
            collectionView.reloadData()
        }
        
        
    }
    
    func notification(displayName: String){
    
        let chatNotification = UNMutableNotificationContent()
        chatNotification.title = "Noir Chat Notification"
        chatNotification.subtitle = "You Have a New Chat message from " + displayName
        chatNotification.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier:"Noir", content: chatNotification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func mediaMessageReceived(senderID: String, media: PFFile, messageID: String) {
        
        if messageIDs.contains(messageID){
            
            collectionView.reloadData()
            
        } else {
            messageIDs.append(messageID)
            
            var pictureMessage = UIImage()
            
            let imageM = JSQPhotoMediaItem()
            
            let imageFile = media 
            
            imageFile.getDataInBackground(block: {(data, error) in
                
                if let imageData = data {
                    pictureMessage = UIImage(data: imageData)!
                    imageM.image = pictureMessage
                }
                
            })
            
            messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, media: imageM))
            
            collectionView.reloadData()
        }
        
        
    }
    
    func chatAvatar(){
        let imageFile = PFUser.current()?["mainPhoto"] as! PFFile
        
        imageFile.getDataInBackground(block: {(data, error) in
            
            if let imageData = data {
                self.avatar = (UIImage(data: imageData)!)
                
            } else {
                self.avatar = (UIImage(named: "default_user_image.png")!)
            }
        })
        do{
            let sender = try PFQuery.getUserObject(withId: displayedUserID)
            let imageFile = sender["mainPhoto"] as! PFFile
            
            imageFile.getDataInBackground(block: {(data, error) in
                
                if let imageData = data {
                    self.senderavatar = (UIImage(data: imageData)!)
                    
                } else {
                    self.senderavatar = (UIImage(named: "default_user_image.png")!)
                }
            })
            
        }catch{
            
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
        chat["chatID"] = chatID
        chat["app"] = "noir"
        
        
        //let chatData : Dictionary<String, Any> = ["senderId": senderID, "senderName": senderName, "text": text]
        
        chat.saveInBackground { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                self.scrollToBottom(animated: true)
                self.automaticallyScrollsToMostRecentMessage = true
                
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
            chat["chatID"] = chatID
            chat["app"] = "noir"
            
            chat.saveInBackground { (success, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    
                }
                
            }
        } else {
            print("There was an error sending the image to the database")
        }
    }
    
    //end del functions
    
    
    //Collection View
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.item]
        
    }
    
    //TIMESTAMP - uncomment to turn on. Currently bugged.
    
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
//        let message: JSQMessage = self.messages[indexPath.item]
//
//        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
//    }
//
//    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
//        return 15.0
//    }
    
    //END TIMESTAMP
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let msg = messages[indexPath.item]
        
        if (msg.media as? JSQPhotoMediaItem) != nil {
            
        }
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        // Configure the cell
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        let message = messages[indexPath.item]
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: outGoingColor)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: inComingColor)
        }
    
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.item]
        
        if message.senderId == self.senderId {
            return JSQMessagesAvatarImageFactory.avatarImage(with: avatar, diameter: 30)
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(with: senderavatar, diameter: 30)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func commonActionSheet(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
    }

}
