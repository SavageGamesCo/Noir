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
    
    let picker = UIImagePickerController()


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
        
        self.observeMessages()
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.item]
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let msg = messages[indexPath.item]
        
        if msg.isMediaMessage {
            if let mediaItem = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerController = AVPlayerViewController()
                
                playerController.player = player
                self.present(playerController, animated: true, completion: nil)
            } else if let mediaItem = msg.media as? JSQPhotoMediaItem {
                
                
            }
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
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ChatViewController.observeMessages), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    func observeMessages(){
        let chat = PFObject(className: "Chat")
        
        let query = PFQuery(className: "Chat")
        
        query.whereKey("toUser", equalTo: displayedUserID)
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                print(error)
            } else if let messages = objects {
                for message in messages {
                    if message["senderID"] as? String == PFUser.current()?.objectId! {
                        if let senderID = message["senderID"] as? String {
                            if let text = message["text"] as? String {
                                if let messageID = message.objectId {
                                    self.messageReceived(senderID: senderID, text: text, messageID: messageID)
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
        
        let videos = UIAlertAction(title: "Videos", style: .default, handler: { (alert: UIAlertAction) in
            
            self.chooseMedia(type: kUTTypeMovie)
            
        })
        
        alert.addAction(photos)
        alert.addAction(videos)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let img = JSQPhotoMediaItem(image: pic)
            
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
        //let message = messages[indexPath.item]
        
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: avatar, diameter: 30)
        
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
    
    //end del functions

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
