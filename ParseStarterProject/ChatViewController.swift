//
//  ChatViewController.swift
//  
//
//  Created by Lynx on 5/3/17.
//
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import SDWebImage


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
        
        
        self.senderId = Authentication.Instance.userID()
        self.senderDisplayName = Authentication.Instance.username
        
        MessagesHandler.Instance.observeMessages()
        
        MessagesHandler.Instance.observeMediaMessages()
        
        self.collectionView.backgroundView?.backgroundColor = bkgColor
        
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
    
    

    //Functions
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        var toUserName = String()
        
        MessagesHandler.Instance.sendMessage(senderID: senderId, senderName: senderDisplayName, toUser: displayedUserID, toUserName: toUserName, text: text)
        
        finishSendingMessage()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = true
        DispatchQueue.main.async {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
            
            let data = UIImageJPEGRepresentation(pic, 0.05)
            
            MessagesHandler.Instance.sendMedia(image: data, video: nil, senderID: senderId, senderName: senderDisplayName, toUser:displayedUserID, toUserName: "")
            
        
        } else if let vid = info [UIImagePickerControllerMediaURL] as? URL {
            
            
            MessagesHandler.Instance.sendMedia(image: nil, video: vid, senderID: senderId, senderName: senderDisplayName, toUser: displayedUserID, toUserName: "")
        
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
    func messageReceived(senderID: String, senderName: String, text: String) {
        
        messages.append(JSQMessage(senderId: senderID, displayName: senderName, text: text))
        
        collectionView.reloadData()
    }
    
    func mediaMessageReceived(senderID: String, senderName: String, url: String) {
        
        if let mediaURL = URL(string: url){
            
            do {
                
                let data = try Data(contentsOf: mediaURL)
                
                if let _ = UIImage(data: data) {
                    let _ = SDWebImageDownloader.shared().downloadImage(with: mediaURL, options: [], progress: nil, completed: { (image, data, error, finished) in
                        
                        DispatchQueue.main.async {
                            
                            let photo = JSQPhotoMediaItem(image: image)
                            
                            if senderID == self.senderId {
                                photo?.appliesMediaViewMaskAsOutgoing = true
                            } else {
                                photo?.appliesMediaViewMaskAsOutgoing = false
                            }
                            
                            self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: photo))
                            
                            self.collectionView.reloadData()
                        }
                        
                        
                        
                    })
                } else {
                    let video = JSQVideoMediaItem(fileURL: mediaURL, isReadyToPlay: true)
                    
                    if senderID == self.senderId {
                        video?.appliesMediaViewMaskAsOutgoing = true
                    } else {
                        video?.appliesMediaViewMaskAsOutgoing = false
                    }
                    
                    self.messages.append(JSQMessage(senderId: senderID, displayName: senderName, media: video))
                    
                    self.collectionView.reloadData()
                    
                }
                
                
            } catch {
            
            }
            
        }
        
            collectionView.reloadData()

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
