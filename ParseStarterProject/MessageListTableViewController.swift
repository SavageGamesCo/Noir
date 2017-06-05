//
//  MessagesTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 5/2/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import Firebase
import GoogleMobileAds
import UserNotifications

private let reuseIdentifier = "Cell"
private let CHAT_SEGUE = "toChat"

class MessagesTableViewController: UITableViewController, UIToolbarDelegate {
    
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    
    private var subscription: Subscription<PFObject>!
   
    
    @IBOutlet var msgTableView: UITableView!
    
    @IBOutlet weak var adBannerView: GADBannerView!
    var senderID = [String]()
    var senderName = [String]()
    var senderPic = [UIImage]()
    var senderMessage = [String]()
    
    var senders = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getMessages()
        
        badge = 0
        UIApplication.shared.applicationIconBadgeNumber = badge
        
        let msgQuery = PFQuery(className: "Chat").whereKey("app", equalTo: APPLICATION).whereKey("toUser", contains: CURRENT_USER!)
        
        self.subscription = self.liveQueryClient.subscribe(msgQuery).handle(Event.created) { _, message in
            // This is where we handle the event
            
            
            
            if Thread.current != Thread.main {
                return DispatchQueue.main.async {
//                    self.chatIcon.tintColor = self.green
                    badge = 1
                    self.notification(displayName: message["senderName"] as! String)
                    print("Got new message")
                    
                }
            } else {
//                self.chatIcon.tintColor = self.green
                badge = 1
                self.notification(displayName: message["senderName"] as! String)
                print("Got new message")
            }
        
        }

        
        if PFUser.current()?["adFree"] as? Bool == false {
            
            print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
            self.adBannerView.adUnitID = "ca-app-pub-9770059916027069/9870169753"
            self.adBannerView.rootViewController = self
            self.adBannerView.load(GADRequest())
            self.adBannerView.isHidden = false
            
        } else if PFUser.current()?["adFree"] as? Bool == true || PFUser.current()?["membership"] as? String != "basic" {
            
            self.adBannerView.isHidden = true
            
        }
        
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.getMessages()
            badge = 0
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.getMessages()
            badge = 0
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return senderID.count
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return senderPic.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MessagesTableViewCell
        
        cell.senderPic.image = self.senderPic[indexPath.row]
        cell.senderName.text = self.senderName[indexPath.row]
        cell.userID = self.senderID[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = msgTableView.cellForRow(at: indexPath as IndexPath) as! MessagesTableViewCell
        
        displayedUserID = cell.userID
        
        performSegue(withIdentifier: CHAT_SEGUE, sender: self)
        
        return
    }
    
    func getMessages() {
        
        let query1 = PFQuery(className: "Chat")
        let query2 = PFQuery(className: "Chat")
        
        query1.whereKey("app", equalTo: APPLICATION).whereKey("chatID", contains: CURRENT_USER!)
//        query2.whereKey("app", equalTo: APPLICATION).whereKey("chatID", contains: displayedUserID + CURRENT_USER!)
        let msgQuery : PFQuery = PFQuery.orQuery(withSubqueries: [query1])
        msgQuery.order(byAscending: "createdAt")
        
//        let msgQuery = PFQuery(className: "Chat")
//        
//        msgQuery.whereKey("toUser", equalTo: CURRENT_USER!)
//        msgQuery.order(byDescending: "createdAt")
        
        msgQuery.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                print(error!)
            } else {
                //being big block
                var messageText = "No Messages"
                var sender = "No Sender"
                
                if let objects = objects {
                    for message in objects {
                      
                        if self.senders.contains(message["senderID"] as! String){
                        
                        } else {
                
                            self.senders.append(message["senderID"] as! String)
                            
                            sender = message["senderID"] as! String
                            
                            let userQuery = PFUser.query()
                            
                            userQuery?.whereKey("objectId", equalTo: sender)
                            
                            userQuery?.findObjectsInBackground(block: { (objects, error) in
                                
                                if let users = objects {
                                    for object in users {
                                        if let user = object as? PFUser {
                                            
                                            if let blockedUsers = PFUser.current()?["blocked"] {
                                                
                                                if (blockedUsers as AnyObject).contains(user.objectId! as String!) {
                                                    
                                                    
                                                    
                                                } else if user.objectId != CURRENT_USER {
                                                    
                                                    let imageFile = user["mainPhoto"] as! PFFile
                                                    
                                                    imageFile.getDataInBackground(block: { (data, error) in
                                                        
                                                        if let imageData = data {
                                                            
                                                            self.senderPic.append(UIImage(data: imageData)!)
                                                            self.senderID.append(message["senderID"] as! String)
                                                            self.senderName.append((user.username!))
                                                            
                                                        }
                                                    })
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
                //end big block
                self.msgTableView.reloadData()
            }
        }
    }
    
    func notification(displayName: String){
        
        let chatNotification = UNMutableNotificationContent()
        chatNotification.title = "Noir Chat Notification"
        chatNotification.subtitle = "You Have a New Chat message from " + displayName
        chatNotification.badge = badge as NSNumber
        chatNotification.sound = .default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier:"Noir", content: chatNotification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
