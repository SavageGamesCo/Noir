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
    

    @IBOutlet var MainView: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        self.showLoadEarlierMessagesHeader = true
        
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
        
//        let imageFile = PFUser.current()?["mainPhoto"] as! PFFile
        
//        imageFile.getDataInBackground(block: {(data, error) in
//            
//            if let imageData = data {
//                self.avatar = (UIImage(data: imageData)!)
//                
//            } else {
//                self.avatar = (UIImage(named: "default_user_image.png")!)
//            }
//        })
        
        //setup of Current USer
        
        //Setup the color of the background
        self.collectionView.backgroundView?.backgroundColor = CHAT_BACKGROUND_COLOR
        self.inputToolbar.contentView.leftBarButtonItem = nil
        
        self.collectionView.collectionViewLayout.springinessEnabled = true
        
        
        //observers
        self.initMessages()
        
        
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
            self.observeMessages()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    func initMessages(){
        
        DispatchQueue.main.async {
            
        self.chatID = CURRENT_USER! + displayedUserID
        
        let query1 = PFQuery(className: "Chat")
        let query2 = PFQuery(className: "Chat")
        
        query1.whereKey("app", equalTo: APPLICATION).whereKey("chatID", contains: CURRENT_USER! + displayedUserID)
        query2.whereKey("app", equalTo: APPLICATION).whereKey("chatID", contains: displayedUserID + CURRENT_USER!)
        let query3 : PFQuery = PFQuery.orQuery(withSubqueries: [query1,query2])
            query3.limit = 2000
        query3.order(byDescending: "createdAt")
        
        query3.cachePolicy = .networkElseCache
        
            query3.order(byAscending: "createdAt")
        
        
            query3.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                print(error!)
            } else if let messages = objects {
                for message in messages {
                        if let senderID = message["senderID"] as? String {
                            if let text = message["text"] as? String {
                                if let messageID = message.objectId {
                                    if let cID = message["ChatID"] as? String {
                                        self.chatID = cID
                                    }
                                    //self.chatAvatar()
                                    self.messageReceived(senderID: senderID, text: text, messageID: messageID, chatID: self.chatID, date: message.createdAt! as NSDate)
                                    
                                    self.scrollToBottom(animated: true)
                                    
                                    self.automaticallyScrollsToMostRecentMessage = true
                                    
                                    print(messages.count)
                                }
                            }
                        }
                    }
                }
            }
        }

        
    }
    
    
    func observeMessages(){
        DispatchQueue.main.async {
            
            let msgQuery = PFQuery(className: "Chat")
            
            msgQuery.whereKey("app", equalTo: APPLICATION).whereKey("chatID", contains: CURRENT_USER!)
            
            self.subscription = self.liveQueryClient.subscribe(msgQuery).handleEvent{ _, message in
                
                let query1 = PFQuery(className: "Chat")
                let query2 = PFQuery(className: "Chat")
                
                query1.whereKey("app", equalTo: APPLICATION).whereKey("chatID", equalTo: CURRENT_USER! + displayedUserID)
                query2.whereKey("app", equalTo: APPLICATION).whereKey("chatID", equalTo: displayedUserID + CURRENT_USER!)
                
                let query3 : PFQuery = PFQuery.orQuery(withSubqueries: [query1,query2])
                query3.limit = 2000
                
                query3.order(byAscending: "createdAt")
                
                
                query3.cachePolicy = .networkElseCache
                
                query3.findObjectsInBackground { (objects, error) in
                    
                    if error != nil {
                        print(error!)
                    } else if let messages = objects {
                        for message in messages {
                                if let senderID = message["senderID"] as? String {
                                    if let text = message["text"] as? String {
                                        if let messageID = message.objectId {
                                            
//                                            self.chatAvatar()
                                            self.messageReceived(senderID: senderID, text: text, messageID: messageID, chatID: self.chatID, date: message.createdAt! as NSDate)
                                            
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
    
    
//    func observeMediaMessages() {
//        DispatchQueue.main.async {
//            
//            let msgQuery = PFQuery(className: "Chat")
//            
//            msgQuery.whereKeyExists("media").whereKey("app", equalTo: APPLICATION)
//            
//            
//            self.subscription = self.liveQueryClient.subscribe(msgQuery).handleEvent{ _, message in
//            
//                let query = PFQuery(className: "Chat")
//                
//                
//                query.order(byAscending: "createdAt")
//                
//                query.findObjectsInBackground { (objects, error) in
//                    
//                    if error != nil {
//                        print(error!)
//                    } else if let messages = objects {
//                        for message in messages {
//                            if (message["senderID"] as? String == PFUser.current()?.objectId! && message["toUser"] as? String == displayedUserID) || (message["senderID"] as? String == displayedUserID && message["toUser"] as? String == PFUser.current()?.objectId!)  {
//                                if let senderID = message["senderID"] as? String {
//                                    if let media = message["media"] as? PFFile {
//                                        if let messageID = message.objectId {
//                                            
////                                            self.chatAvatar()
//                                            self.mediaMessageReceived(senderID: senderID, media: media, messageID: messageID)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                }
//
//            }
//            
//        }
//        collectionView.reloadData()
//    }
    
    
//    override func didPressAccessoryButton(_ sender: UIButton!) {
//        
//        let alert = UIAlertController(title: "Send Media", message: "Select A Photo", preferredStyle: .actionSheet)
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        let photos = UIAlertAction(title: "Photos", style: .default, handler: { (alert: UIAlertAction) in
//            
//            self.chooseMedia(type: kUTTypeImage)
//        
//        })
//        
//        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction) in
//            
//            self.chooseMedia(type: kUTTypeImage)
//            
//        })
//        
//        //alert.addAction(photos)
//        //alert.addAction(camera)
//        alert.addAction(cancel)
//        
//        alert.popoverPresentationController?.sourceView = view
//        
//        present(alert, animated: true, completion: nil)
//        
//    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            
//            let imageData = UIImageJPEGRepresentation( pic, 0.5)
//            
//            let image = PFFile(name: "mainProfile.jpg", data: imageData!)
//            
//            var toUserName = String()
//            
//            do{
//                
//                let query = try PFQuery.getUserObject(withId: displayedUserID)
//                
//                toUserName = query.username!
//                
//            } catch {
//                
//            }
//            
//            sendMedia(image: image, senderID: senderId, senderName: senderDisplayName, toUser: displayedUserID, toUserName: toUserName)
//        
//        } else if let vid = info [UIImagePickerControllerMediaURL] as? URL {
//            
//            let video = JSQVideoMediaItem(fileURL: vid, isReadyToPlay: true)
//            
//            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
//        
//        }
//        
//        picker.dismiss(animated: true, completion: nil)
//        collectionView.reloadData()
//        
//    }
    
    //picker functions
    
//    private func chooseMedia(type: CFString){
//        picker.mediaTypes = [type as String]
//        
//        present(picker, animated: true, completion: nil)
//    }
    
    //end picker functions
    
    //delegate functions
    func messageReceived(senderID: String, text: String, messageID: String, chatID: String, date: NSDate) {
        
        if messageIDs.contains(messageID){

        
        } else {
            messageIDs.append(messageID)
            
                messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, text: text))
                
//                notification(displayName: senderDisplayName)
                
                collectionView.reloadData()
            
        }
        
        
    }
    
    func notification(displayName: String){
    
        let chatNotification = UNMutableNotificationContent()
        chatNotification.title = "Noir Chat Notification"
        chatNotification.subtitle = "You Have a New Chat message from " + displayName
        chatNotification.badge = badge as NSNumber
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier:APPLICATION, content: chatNotification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
//    func mediaMessageReceived(senderID: String, media: PFFile, messageID: String) {
//        
//        if messageIDs.contains(messageID){
//            
//            collectionView.reloadData()
//            
//        } else {
//            messageIDs.append(messageID)
//            
//            var pictureMessage = UIImage()
//            
//            let imageM = JSQPhotoMediaItem()
//            
//            let imageFile = media 
//            
//            imageFile.getDataInBackground(block: {(data, error) in
//                
//                if let imageData = data {
//                    pictureMessage = UIImage(data: imageData)!
//                    imageM.image = pictureMessage
//                }
//                
//            })
//            
//            messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, media: imageM))
//            
//            collectionView.reloadData()
//        }
//        
//        
//    }
    
//    func chatAvatar(){
//        let imageFile = PFUser.current()?["mainPhoto"] as! PFFile
//        
//        imageFile.getDataInBackground(block: {(data, error) in
//            
//            if let imageData = data {
//                self.avatar = (UIImage(data: imageData)!)
//                
//            } else {
//                self.avatar = (UIImage(named: "default_user_image.png")!)
//            }
//        })
//        do{
//            let sender = try PFQuery.getUserObject(withId: displayedUserID)
//            let imageFile = sender["mainPhoto"] as! PFFile
//            
//            imageFile.getDataInBackground(block: {(data, error) in
//                
//                if let imageData = data {
//                    self.senderavatar = (UIImage(data: imageData)!)
//                    
//                } else {
//                    self.senderavatar = (UIImage(named: "default_user_image.png")!)
//                }
//            })
//            
//        }catch{
//            
//        }
//    }
    
    func sendMessage(senderID: String, senderName: String, toUser: String, toUserName: String, text: String) {
        
        let chat = PFObject(className: "Chat")
        
        chat["senderID"] = senderID
        chat["senderName"] = senderName
        chat["text"] = text
        chat["url"] = ""
        chat["toUser"] = toUser
        chat["toUserName"] = toUserName
        chat["chatID"] = chatID
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
                
                self.scrollToBottom(animated: true)
                self.automaticallyScrollsToMostRecentMessage = true
                
            }
            
        }
        
    }
    
//    func sendMedia(image: PFFile?, senderID: String, senderName: String, toUser: String, toUserName: String){
//        
//        if image != nil {
//            let chat = PFObject(className: "Chat")
//            
//            chat["media"] = image
//            chat["senderID"] = senderID
//            chat["senderName"] = senderName
//            chat["toUser"] = toUser
//            chat["toUserName"] = toUserName
//            chat["chatID"] = chatID
//            chat["app"] = APPLICATION
//            
//            chat.saveInBackground { (success, error) in
//                
//                if error != nil {
//                    print(error!)
//                } else {
//                    
//                }
//                
//            }
//        } else {
//            print("There was an error sending the image to the database")
//        }
//    }
    
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
            return bubbleFactory?.outgoingMessagesBubbleImage(with: CHAT_OUTGOING_COLOR)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: CHAT_INCOMING_COLOR)
        }
    
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.item]
        
        if message.senderId == self.senderId {
            return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "N", backgroundColor: CHAT_BACKGROUND_COLOR, textColor: CHAT_ALERT_COLOR, font: SYSTEM_FONT, diameter: 30)
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "N", backgroundColor: CHAT_BACKGROUND_COLOR, textColor: ONLINE_COLOR, font: SYSTEM_FONT, diameter: 30)
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
