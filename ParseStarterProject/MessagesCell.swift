//
//  MessagesCell.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds


class MessagesCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        if PFUser.current()?["membership"] as! String == "basic" {
            layout.sectionInset.bottom = 50
        } else {
            layout.sectionInset.bottom = 15
        }
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var navigationController: MainViewController = {
        
        let cv = MainViewController()
        cv.navigationController?.delegate = self
        
        
        return cv
    }()
    
    var activitityIndicatorView: UIActivityIndicatorView?
    let refreshControl = UIRefreshControl()
    
    let cellID = "cellID"
    
    var messages = Array<Message?>()
    
//    var messages : [Message] = []
    
    var newMessages = Array<Message?>()
    
    var messageID = [String()]
    
    
    func setupData(){
        
        messageID.removeAll()
        newMessages.removeAll()
        messages.removeAll()
        
            let query1 = PFQuery(className: "Chat")
            
            query1.whereKey("app", equalTo: APPLICATION).whereKey("chatID", contains: CURRENT_USER!)
            
            let msgQuery : PFQuery = PFQuery.orQuery(withSubqueries: [query1])
            
//            msgQuery.limit = 500
        
            msgQuery.order(byDescending: "createdAt")
            
            msgQuery.findObjectsInBackground { (objects, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    
                    if let objects = objects {
                        for message in objects {
                            
                            let userQuery = PFUser.query()
                            
                            userQuery?.whereKey("objectId", equalTo: message["senderID"])
                            
                            userQuery?.findObjectsInBackground(block: { (objects, error) in
                                
                                if let users = objects {
                                    for object in users {
                                        if let user = object as? PFUser {
                                            if let blockedUsers = PFUser.current()?["blocked"] {
                                                
                                                if (blockedUsers as AnyObject).contains(user.objectId! as String?) {
                                                    
                                                    return
                                                    
                                                } else if user.objectId != CURRENT_USER && user.objectId != nil {
                                                    
                                                    
                                                    var userIDUnwrapped = String()
                                                    if let userID: String = user.objectId {
                                                        userIDUnwrapped = userID
                                                    }
                                                    if self.messageID.contains(userIDUnwrapped) {
                                                        return
                                                    } else {
                                                        self.messageID.append(userIDUnwrapped)
                                                        let NewMessage = Message()
                                                        let NewSender = Sender()
                                                        
                                                        let imageFile = user["mainPhoto"] as! PFFile
                                                        imageFile.getDataInBackground(block: { (data, error) in
                                                            if let imageData = data {
                                                                
                                                                let profileImage = UIImage(data: imageData)
                                                                
                                                                
                                                                NewSender.name = user.username!
                                                                NewSender.profileImage = profileImage
                                                                NewSender.userID = user.objectId!
                                                                NewMessage.sender = NewSender
                                                                NewMessage.text = message["text"] as? String
                                                                NewMessage.toID = message["toUser"] as? String
                                                                NewMessage.fromID = message["senderID"] as? String
                                                                NewMessage.date = message.createdAt
                                                                NewMessage.messageID = message.objectId
                                                                
//                                                                if message["messageRead"] as? Bool == nil {
//                                                                    NewMessage.readMessage = false
//                                                                } else {
//                                                                    NewMessage.readMessage = message["messageRead"] as? Bool
//                                                                }
                                                                
//                                                                self.newMessages.append(NewMessage)
                                                                
                                                                
                                                                
                                                            }
                                                            self.newMessages.append(NewMessage)
                                                        })
//                                                        self.messages.append(NewMessage)
                                                
                                                        
                                                    }
                                                    
                                                    
                                                }
                                            }
                                            
                                        }
                                        //end of for loop
                                        
                                        self.messages = self.newMessages.sorted(by: { ($0?.date)! > ($1?.date)! })
                                        DispatchQueue.main.async {
                                            
                                            self.collectionView.reloadData()
                                        }

                                    }
                                }
                            })
                            
                        }
                    }
                    
                }
            
            
        }
        
    }
    
    @objc func refreshing(){
        
        self.clearAllBadges()
        self.setupData()
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
        self.refreshControl.endRefreshing()
        self.activitityIndicatorView?.stopAnimating()
        
        
    }
    
    func clearAllBadges() {
        badge = 0
        UIApplication.shared.applicationIconBadgeNumber = badge
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground { (success, error) -> Void in
            if success {
                print("cleared badges")
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            else {
                print("failed to clear badges")
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]-50-|", views: collectionView)
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(RecentMessagesCell.self, forCellWithReuseIdentifier: cellID)
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        if activitityIndicatorView != nil {
            collectionView.addSubview(activitityIndicatorView!)
            activitityIndicatorView?.startAnimating()
        }
        
        
        refreshControl.tintColor = Constants.Colors.NOIR_TINT
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName:  Constants.Colors.NOIR_TINT]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Messages...", attributes: attributes)
        refreshControl.contentHorizontalAlignment = .center
        
        
        refreshControl.addTarget(self, action: #selector(refreshing), for: .valueChanged)

        clearAllBadges()

        self.setupData()
        
    }
    
    func fetchMessages(){
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return number of members
        
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RecentMessagesCell
        
        if let message = messages[indexPath.item] {
            cell.message = message
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (window?.frame.width)!, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.cellForItem(at: indexPath)?.layoutSubviews()
        let layout = UICollectionViewFlowLayout()
        
        let controller = ChatController(collectionViewLayout: layout)
        controller.sender = self.messages[indexPath.item]?.sender
           
        self.window?.rootViewController?.present(controller, animated: true, completion: nil)
            
        
        

        
    }
}
