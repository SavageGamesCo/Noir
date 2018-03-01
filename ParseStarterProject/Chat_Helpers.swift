//
//  Chat_Helpers.swift
//  Noir
//
//  Created by Lynx on 3/1/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import MobileCoreServices
import AVKit

extension ChatController {
    
    func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alert = UIAlertController(title: "Send Media", message: "Select A Photo", preferredStyle: .actionSheet)
        
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
            
            let imageData = UIImageJPEGRepresentation( pic, 0.3)
            
            let image = PFFile(name: "mainProfile.jpg", data: imageData!)
            
            var toUserName = String()
            
            do{
                
                let query = try PFQuery.getUserObject(withId: displayedUserID)
                
                toUserName = query.username!
                
            } catch {
                
            }
            
            sendMedia(image: image, senderID: (PFUser.current()?.objectId)!, senderName: (PFUser.current()?.username)!, toUser: (member?.memberID)!, toUserName: (member?.memberName)!, text: nil)
            
            if PFUser.current()?["membership"] as! String == "basic" {
                
                if imagesSent < 5 {
                    imagesSent += 1
                }
            }
            
            
            
        }
        
        //        else if let vid = info [UIImagePickerControllerMediaURL] as? URL {
        //
        //            let video = JSQVideoMediaItem(fileURL: vid, isReadyToPlay: true)
        //
        //            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: video))
        //
        //        }
        
        
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //    picker functions
    
    private func chooseMedia(type: CFString){
        self.picker.mediaTypes = [type as String]
        
        present(self.picker, animated: true, completion: nil)
    }
    
    //end picker functions
    
    //delegate functions
//    func messageReceived(senderID: String, text: String, messageID: String, chatID: String, date: NSDate) {
//
//        if messageIDs.contains(messageID){
//
//
//        } else {
//            messageIDs.append(messageID)
//
//            messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, text: text))
//
//            //                notification(displayName: senderDisplayName)
//
//            collectionView.reloadData()
//
//
//        }
//
//
//    }
    
}
