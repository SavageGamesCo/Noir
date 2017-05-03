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

class ChatViewController: JSQMessagesViewController {
    
    private var messages = [JSQMessage]()
    
    var avatar = UIImage()


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return messages[indexPath.item]
        
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
        
        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        
        collectionView.reloadData()
        
        finishSendingMessage()
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: avatar, diameter: 30)
        
    }

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
