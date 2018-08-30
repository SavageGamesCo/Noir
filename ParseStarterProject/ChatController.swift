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
import NotificationCenter
import GoogleMobileAds
import ALRadialMenu
import Spring

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADInterstitialDelegate {
    
    let picker = UIImagePickerController()
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    private var subscription: Subscription<PFObject>!
//    var interstitial: GADInterstitial!
    let cellID = "cellID"
    
    var memberID = String()
    var memberName = String()
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIView?
    var chatMessages = [Message()]
    var selectedMember = Member()
    
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
            let profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: nil, action: #selector(showMenu))
            profileButton.tintColor = Constants.Colors.NOIR_TINT
            navTitle.rightBarButtonItem = dismissButton
            navTitle.leftBarButtonItem = profileButton
            navbar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
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
            dismissButton.tintColor = Constants.Colors.NOIR_TINT
            let profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: nil, action: #selector(showMenu))
            profileButton.tintColor = Constants.Colors.NOIR_TINT
            navTitle.rightBarButtonItem = dismissButton
            navTitle.leftBarButtonItem = profileButton
            navbar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Colors.NOIR_NAV_BAR_TEXT, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
            navbar.setItems([navTitle], animated: true)
            
            self.memberID = (member?.memberID)!
            self.memberName = (member?.memberName)!
            
        }
    }
    
//    var member = Member()
    
    func fetchMember(){
        let query = PFUser.query()
        
        query?.whereKey("objectId", equalTo: memberID).whereKey("app", equalTo: "noir")
        
        //Show All Users
        query?.getFirstObjectInBackground(block: { (object, error) in
            if error != nil {
                
            } else if let user = object as? PFUser {
                
                
                let imageFile = user["mainPhoto"] as! PFFile
                imageFile.getDataInBackground(block: {(data, error) in
                    
                    if user["echo"] as! Bool {
                        self.selectedMember.echo = true
                    } else {
                        self.selectedMember.echo = false
                    }
                    
                    if let memberIDText = user.objectId {
                        self.selectedMember.memberID = memberIDText
                    } else {
                        return
                    }
                    
                    if let memberNameText = user.username {
                        self.selectedMember.memberName = memberNameText
                    } else {
                        return
                    }
                    
                    if let aboutText = user["about"] as? String {
                        self.selectedMember.about = aboutText
                    } else {
                        self.selectedMember.about = "Unanswered"
                    }
                    
                    if let ageText = user["age"] as? String {
                        self.selectedMember.age = ageText
                    } else {
                        self.selectedMember.age = "Unanswered"
                    }
                    
                    if let genderText = user["gender"] as? String {
                        self.selectedMember.gender = genderText
                    } else {
                        self.selectedMember.gender = "Unanswered"
                    }
                    
                    if let bodyText = user["body"] as? String {
                        self.selectedMember.body = bodyText
                    } else {
                        self.selectedMember.body = "Unanswered"
                    }
                    
                    if let heightText = user["height"] as? String {
                        self.selectedMember.height = heightText
                    } else {
                        self.selectedMember.height = "Unanswered"
                    }
                    
                    if let weightText = user["weight"] as? String {
                        self.selectedMember.weight = weightText
                    } else {
                        self.selectedMember.weight = "Unanswered"
                    }
                    
                    if let maritalStatusText = user["marital"] as? String {
                        self.selectedMember.maritalStatus = maritalStatusText
                    } else {
                        self.selectedMember.maritalStatus = "Unanswered"
                    }
                    
                    if let raceText = user["ethnicity"] as? String {
                        self.selectedMember.race = raceText
                    } else {
                        self.selectedMember.race = "Unanswered"
                    }
                    
                    if let statusText = user["hivStatus"] as? String {
                        self.selectedMember.status = statusText
                    } else {
                        self.selectedMember.status = "Unanswered"
                    }
                    
                    if user["location"] != nil {
                        let mlat = (user["location"] as AnyObject).latitude
                        self.selectedMember.mLat = mlat
                    } else {
                        self.selectedMember.mLat = 0
                    }
                    
                    if user["location"] != nil {
                        let mlong = (user["location"] as AnyObject).longitude
                        self.selectedMember.mLong = mlong
                    } else {
                        self.selectedMember.mLong = 0
                    }
                    
                    self.selectedMember.memberOnline = true
                    
                    let imageData = data
                    self.selectedMember.memberImage = (UIImage(data: imageData!)!)
                    
                })
            }
        })
    }
    
    
    @objc func handleDismiss(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var admobDelegate = AdMobDelegate()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        currentVc = self
        
        checkPermission()
        
        picker.delegate = self
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 50, left: 0, bottom: 50, right: 0)
        collectionView?.setCollectionViewLayout(layout, animated: true)
        
        collectionView?.keyboardDismissMode = .interactive
        
        observeMessages()
        
        
        
        if PFUser.current()?["membership"] as! String == "basic" && PFUser.current()?["adFree"] as! Bool != true{
            admobDelegate.showAd()
        }
        
        

    }
    
    
    func setupKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    
    
    func performZoomForStartingImageView(startingImageView: UIImageView){
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.contentMode = .scaleAspectFill
        
        
        
        if let keyWindow = UIApplication.shared.keyWindow{
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = Constants.Colors.NOIR_BLACK
            blackBackgroundView?.alpha = 0
            
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                
                self.inputContainerView.alpha = 0
                
                self.startingImageView?.isHidden = true
                
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
                
            }, completion: { (completed) in
                
            })
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                
                
                
            }, completion: nil)
        }
    }
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        
        if let zoomout = tapGesture.view {
            zoomout.layer.cornerRadius = 10
            zoomout.layer.masksToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomout.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }, completion: { (completed) in
                zoomout.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
            
        }
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        
        UIView.animate(withDuration: keyboardDuration!) {
            
            let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
            let lastItemIndex = IndexPath(item: item, section: 0)
            
            self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
            self.collectionView?.layoutIfNeeded()
        
        }
        
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        
        let keyboardDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        
        UIView.animate(withDuration: keyboardDuration!) {
            
            let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
            let lastItemIndex = IndexPath(item: item, section: 0)
            
            self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: true)
            self.collectionView?.layoutIfNeeded()
        }
        
        
        
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = Constants.Colors.NOIR_WHITE
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.tintColor = Constants.Colors.NOIR_TINT
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let mediaButton = UIButton(type: .roundedRect)
        mediaButton.setImage(UIImage(named: "photo-7"), for: .normal)
        mediaButton.tintColor = Constants.Colors.NOIR_TINT
        mediaButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(sendButton)
        containerView.addSubview(mediaButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        mediaButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        mediaButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        mediaButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mediaButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        mediaButton.addTarget(self, action: #selector(handleMedia), for: .touchUpInside)
        
        
        containerView.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: mediaButton.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        //        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        containerView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: self.inputTextField)
        
        let line = UIView()
        line.backgroundColor = Constants.Colors.NOIR_RECENT_MESSAGES_DIVIDER
        line.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(line)
        
        line.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        line.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    lazy var detailsView: UserDetailsLauncher = {
        
        let dv = UserDetailsLauncher()
        return dv
    }()
    
    lazy var galleryView: GalleryViewLauncher = {
        
        let gv = GalleryViewLauncher()
        
        return gv
    }()
    
    @objc private func showStats(){
        
        detailsView.showDetails(member: selectedMember)
        
    }
    @objc private func showGallery(){
        
        galleryView.showSettings(member: selectedMember)
        
    }
    
    
    @objc private func favorite() {
        
        APIService.sharedInstance.favorite(member: selectedMember)
        favoriteAnim()
        
    }
    
    @objc private func flirt() {
        
        APIService.sharedInstance.flirt(member: selectedMember)
        flirtAnim()
        
    }
    
    func favoriteAnim() {
        
        let favoriteIcon = SpringImageView()
        
        favoriteIcon.image = UIImage(named: "noir_stars.png")
        favoriteIcon.contentMode = .scaleAspectFill
        favoriteIcon.autostart = true
        favoriteIcon.animation = "zoomIn"
        favoriteIcon.animateToNext {
            
            favoriteIcon.delay = 0.5
            favoriteIcon.animation = "zoomOut"
            favoriteIcon.animateTo()
            
        }
        
        
        favoriteIcon.frame = CGRect(x: self.view.center.x, y: self.view.center.y , width: 600, height: 362)
        
        favoriteIcon.center = CGPoint(x: self.view.center.x - (self.view.frame.width / 20), y: self.view.center.y - (self.view.frame.height / 15))
        
        self.view.addSubview(favoriteIcon)
        
    }
    
    func flirtAnim() {
        
        let flirtGraphic = SpringImageView()
        
        flirtGraphic.image = UIImage(named: "noir_heart.png")
        flirtGraphic.contentMode = .scaleAspectFill
        flirtGraphic.autostart = true
        flirtGraphic.animation = "zoomIn"
        
        flirtGraphic.animateToNext {
            
            flirtGraphic.delay = 0.5
            flirtGraphic.animation = "zoomOut"
            flirtGraphic.animateTo()
            
        }
        
        flirtGraphic.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 300)
        
        flirtGraphic.center = CGPoint(x: self.view.center.x - (self.view.frame.width / 20), y: self.view.center.y - (self.view.frame.width / 15))
        
        self.view.addSubview(flirtGraphic)
        
    }
    
    @objc private func block(){
        
        APIService.sharedInstance.blockUserChat(member: selectedMember, view: self.view)
        
        
    }
    
    @objc func showMenu(){
        
        fetchMember()
        
        var buttons = [ALRadialMenuButton]()
        
        let statsButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        statsButton.setImage(UIImage(named: "stats_icon")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        statsButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        statsButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        statsButton.layer.cornerRadius = 50
        statsButton.addTarget(self, action: #selector(showStats), for: .touchUpInside)
        
        buttons.append(statsButton)
        
        let galleryButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        galleryButton.setImage(selectedMember.memberImage, for: UIControlState.normal)
        galleryButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        galleryButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        galleryButton.layer.cornerRadius = 50
        galleryButton.layer.masksToBounds = true
        galleryButton.imageView?.contentMode = .scaleAspectFill
        galleryButton.addTarget(self, action: #selector(showGallery), for: .touchUpInside)
        
        buttons.append(galleryButton)
        
        
        let blockButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blockButton.setImage(UIImage(named: "block_icon")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        blockButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        blockButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        blockButton.layer.cornerRadius = 50
        blockButton.addTarget(self, action: #selector(block), for: .touchUpInside)
        
        buttons.append(blockButton)
        
        let flirtButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        flirtButton.setImage(UIImage(named: "flirts_full_icon")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        flirtButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        flirtButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        flirtButton.layer.cornerRadius = 50
        flirtButton.addTarget(self, action: #selector(flirt), for: .touchUpInside)
        
        buttons.append(flirtButton)
        
        let favoriteButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        favoriteButton.setImage(UIImage(named: "favorites_fire_icon")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        favoriteButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        favoriteButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        favoriteButton.layer.cornerRadius = 50
        favoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        
        buttons.append(favoriteButton)
        
        
        let senderCenter = CGPoint(x: self.view.center.x, y: self.view.center.y + (self.view.frame.height / 15))
        
        ALRadialMenu().setButtons(buttons: buttons).setRadius(radius: Double(self.view.frame.width / 3)).setAnimationOrigin(animationOrigin: senderCenter).setOverlayBackgroundColor(backgroundColor: Constants.Colors.NOIR_BLACK.withAlphaComponent(0.7)).presentInView(view: self.view)
//        print(selectedMember.memberName!)
        
    }
    
    override var inputAccessoryView: UIView? {
        
        get {
            
            return inputContainerView
        }
        
    }
    
    override var canBecomeFirstResponder: Bool {
        
        get {
            return true
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        
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
                            self.chatMessages.append(NewMessage)
                            
                        } else {
                            NewMessage.text = message["text"] as? String
                            self.chatMessages.append(NewMessage)
                        }
                        
                        
                        
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
                                        
                                        let image = UIImage(data: imageData)!
                                        
                                        NewMessage.mediaMessage = image
                                    }
                                    
                                })
                                
                                self.chatMessages.append(NewMessage)
                                
                            } else {
                                
                                NewMessage.text = cMessage["text"] as? String
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
               
            })
            
        }
        
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInput(){
        
        let containerView = UIView()
        containerView.backgroundColor = Constants.Colors.NOIR_WHITE
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.tintColor = Constants.Colors.NOIR_TINT
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let mediaButton = UIButton(type: .roundedRect)
        mediaButton.setImage(UIImage(named: "photo-7"), for: .normal)
        mediaButton.sizeToFit()
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
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        containerView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: inputTextField)
        
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
        cell.chatLogController = self
        
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
//            let estimatedFrame = chatMessages[indexPath.item].mediaMessage?.size.height
            
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
