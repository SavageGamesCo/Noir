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


private let reuseIdentifier = "Cell"

class ChatViewController: JSQMessagesViewController, MessageReceivedDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var messages = [JSQMessage]()
    private var messageIDs = [String]()
    
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
        
        do {
            let query = try PFQuery.getUserObject(withId: displayedUserID)
            self.navigationItem.title = query.username
        }catch{
            print("No User Selected")
        }
        
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
        
        self.collectionView.backgroundView?.backgroundColor = bkgColor
        
        
        self.observeMessages()
        self.observeIncomingMessages()
        self.observeMediaMessages()
        self.observeIncomingMediaMessages()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.item]
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let msg = messages[indexPath.item]
        
//        if msg.isMediaMessage {
//            if let mediaItem = msg.media as? JSQVideoMediaItem {
//                let player = AVPlayer(url: mediaItem.fileURL)
//                let playerController = AVPlayerViewController()
//                
//                playerController.player = player
//                self.present(playerController, animated: true, completion: nil)
//            } else if (msg.media as? JSQPhotoMediaItem) != nil {
//                
//                
//            }
//        }
        
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
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */

    //Functions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        var toUserName = String()
        
        do{
            
        let query = try PFQuery.getUserObject(withId: displayedUserID)
        
        toUserName = query.username!
            
        } catch {
        
        }
        
        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, toUser: displayedUserID, toUserName: toUserName, text: text)
        
//        collectionView.reloadData()
        
        finishSendingMessage()
        
    }
    
    var timer: Timer = Timer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = true
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatViewController.observeMessages), userInfo: nil, repeats: true)
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatViewController.observeIncomingMessages), userInfo: nil, repeats: true)
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatViewController.observeMediaMessages), userInfo: nil, repeats: true)
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatViewController.observeIncomingMediaMessages), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func observeMessages(){
        DispatchQueue.main.async {
            
            let query = PFQuery(className: "Chat")
            
            query.whereKey("toUser", equalTo: displayedUserID)
            
            query.findObjectsInBackground { (objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let messages = objects {
                    for message in messages {
                        if message["senderID"] as? String == PFUser.current()?.objectId! {
                            if let senderID = message["senderID"] as? String {
                                if let text = message["text"] as? String {
                                    if let messageID = message.objectId {
                                        let imageFile = PFUser.current()?["mainPhoto"] as! PFFile
                                        
                                        imageFile.getDataInBackground(block: {(data, error) in
                                            
                                            if let imageData = data {
                                                self.avatar = (UIImage(data: imageData)!)
                                                
                                            } else {
                                                self.avatar = (UIImage(named: "default_user_image.png")!)
                                            }
                                        })
                                        self.messageReceived(senderID: senderID, text: text, messageID: messageID)
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
            
            let query = PFQuery(className: "Chat")
            
            query.whereKey("toUser", equalTo: PFUser.current()?.objectId! as Any)
            
            query.findObjectsInBackground { (objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let messages = objects {
                    for message in messages {
                        if message["senderID"] as? String == displayedUserID {
                            if let senderID = message["senderID"] as? String {
                                if let text = message["text"] as? String {
                                    if let messageID = message.objectId {
                                        
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
                                        
                                        self.messageReceived(senderID: senderID, text: text, messageID: messageID)
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
            
            let query = PFQuery(className: "Chat")
            
            query.whereKey("toUser", equalTo: displayedUserID)
            
            query.findObjectsInBackground { (objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let messages = objects {
                    for message in messages {
                        if message["senderID"] as? String == PFUser.current()?.objectId! {
                            if let senderID = message["senderID"] as? String {
                                if let media = message["media"] as? PFFile {
                                    if let messageID = message.objectId {
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

    func observeIncomingMediaMessages() {
        DispatchQueue.main.async {
            
            let query = PFQuery(className: "Chat")
            
            query.whereKey("toUser", equalTo: PFUser.current()?.objectId! as Any)
            
            query.findObjectsInBackground { (objects, error) in
                
                if error != nil {
                    print(error!)
                } else if let messages = objects {
                    for message in messages {
                        if message["senderID"] as? String == displayedUserID {
                            if let senderID = message["senderID"] as? String {
                                if let media = message["media"] as? PFFile {
                                    if let messageID = message.objectId {
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
        
        let alert = UIAlertController(title: "Send Media", message: "Please Select", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let photos = UIAlertAction(title: "Photos", style: .default, handler: { (alert: UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeImage)
        
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeImage)
            
        })
        
        alert.addAction(photos)
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
            
            MessagesHandler.Instance.sendMedia(image: image, senderID: senderId, senderName: senderDisplayName, toUser: displayedUserID, toUserName: toUserName)
//            self.messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: img))
        
        } else if let vid = info [UIImagePickerControllerMediaURL] as? URL {
            
            let video = JSQVideoMediaItem(fileURL: vid, isReadyToPlay: true)
            
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
        
        }
        
        picker.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
        
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
    
    //picker functions
    
    private func chooseMedia(type: CFString){
        picker.mediaTypes = [type as String]
        
        present(picker, animated: true, completion: nil)
    }
    
    
    //end picker functions
    
    //del functions
    func messageReceived(senderID: String, text: String, messageID: String) {
        
//        messages.removeAll()
        if messageIDs.contains(messageID){
            collectionView.reloadData()
        
        } else {
            messageIDs.append(messageID)
            
            messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, text: text))
            
            collectionView.reloadData()
        }
        
        
    }
    
    func mediaMessageReceived(senderID: String, media: PFFile, messageID: String) {
        
        //        messages.removeAll()
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
    
    //end del functions

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
}
