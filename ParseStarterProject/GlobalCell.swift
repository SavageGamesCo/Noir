//
//  FeedCell.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import Firebase
import GoogleMobileAds
import StoreKit
import SwiftyStoreKit
import AVFoundation
import ALRadialMenu
import MapKit
import Spring


class GlobalCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var members: [Member]?
    
    var online = [String]()
    var blocked = [String]()
    var mainViewController: MainViewController?
    var interstitial: GADInterstitial!
    
    //Constants

    
    
    let bundleID = "comsavagecodeNoir"
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    //Private vars
    private var subscription: Subscription<PFObject>!
    
    
    lazy var memberCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var activitityIndicatorView: UIActivityIndicatorView?
    let refreshControl = UIRefreshControl()
    
    lazy var settingsView: SettingsLauncher = {
        let sv = SettingsLauncher()
//        sv.mainViewController = 
        return sv
    }()
    
    lazy var detailsView: UserDetailsLauncher = {
        let dv = UserDetailsLauncher()
        //        sv.mainViewController =
        return dv
    }()
    
    lazy var galleryView: GalleryViewLauncher = {
        let gv = GalleryViewLauncher()
        //        sv.mainViewController =
        return gv
    }()
    
    let cellID = "cellID"
    
//    var tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMenu(sender:,member:)))
    
    override func setupViews() {
        
        backgroundColor = Constants.Colors.NOIR_BACKGROUND
        
        addSubview(memberCollectionView)
        
        if #available(iOS 10.0, *) {
            memberCollectionView.refreshControl = refreshControl
        } else {
            memberCollectionView.addSubview(refreshControl)
        }
        
        if activitityIndicatorView != nil {
            memberCollectionView.addSubview(activitityIndicatorView!)
            activitityIndicatorView?.startAnimating()
        }
        refreshControl.tintColor = Constants.Colors.NOIR_TINT
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName:  Constants.Colors.NOIR_TINT]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Active Members ...", attributes: attributes)
        refreshControl.contentHorizontalAlignment = .center
        
        
        refreshControl.addTarget(self, action: #selector(refreshing), for: .valueChanged)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: memberCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]-50-|", views: memberCollectionView)
        memberCollectionView.register(MemberCell.self, forCellWithReuseIdentifier: cellID)
        let layout = UICollectionViewFlowLayout()
        let width = self.frame.width / 5
        let height = self.frame.width / 5 + 28
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 20
        layout.sectionInset.top = 15
        memberCollectionView.setCollectionViewLayout(layout, animated: true)
        
        setupActivityIndicatorView()
        fetchMembers()
        
        
//        var timer: Timer!
//
//        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(refreshing), userInfo: nil, repeats: true)
//

    }
    
    
//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        
//        DispatchQueue.main.async {
//            self.memberCollectionView.reloadData()
//        }
//        
//    }
    
    func fetchMembers(){
        
        APIService.sharedInstance.fetchGlobalMembers() { (fetchMembers: [Member]) in
            self.members = fetchMembers
            
            DispatchQueue.main.async {
                self.memberCollectionView.reloadData()
            }
            self.refreshControl.endRefreshing()
            self.activitityIndicatorView?.stopAnimating()
            
        }
    }
    
    var selectedMember = Member()
    
    @objc func refreshing(){
        fetchMembers()

    }
    
    func setupActivityIndicatorView() {
        
//        activitityIndicatorView.startAnimating()
    }
    
    @objc private func showStats(){
        detailsView.showDetails(member: selectedMember)
    }
    @objc private func showGallery(){
        galleryView.showSettings(member: selectedMember)
    }
    
    @objc private func showChat(){
        let layout = UICollectionViewFlowLayout()
        
        let controller = ChatController(collectionViewLayout: layout)
        
        controller.member = selectedMember
        
        self.window?.rootViewController?.present(controller, animated: true, completion: nil)
    }
    
    @objc private func favorite(){
        APIService.sharedInstance.favorite(member: selectedMember)
        favoriteAnim()
    }
    
    @objc private func flirt(){
        APIService.sharedInstance.flirt(member: selectedMember)
        flirtAnim()
    }
    
    func favoriteAnim() {
        let favoriteIcon = SpringImageView()
        
        favoriteIcon.image = UIImage(named: "noir_stars.png")
        favoriteIcon.contentMode = .scaleAspectFill
        //flirtGraphic.y = -50
        favoriteIcon.autostart = true
        favoriteIcon.animation = "zoomIn"
        favoriteIcon.animateToNext {
            favoriteIcon.delay = 0.5
            favoriteIcon.animation = "zoomOut"
            favoriteIcon.animateTo()
            
        }
        
        
        favoriteIcon.frame = CGRect(x: memberCollectionView.center.x, y: memberCollectionView.center.y , width: 600, height: 362)
        
        favoriteIcon.center = CGPoint(x: memberCollectionView.center.x - (self.frame.width / 20), y: memberCollectionView.center.y - (self.frame.height / 15))
        
        self.memberCollectionView.addSubview(favoriteIcon)
    }
    
    func flirtAnim(){
        let flirtGraphic = SpringImageView()
        
        flirtGraphic.image = UIImage(named: "noir_heart.png")
        flirtGraphic.contentMode = .scaleAspectFill
        //flirtGraphic.y = -50
        flirtGraphic.autostart = true
        flirtGraphic.animation = "zoomIn"
        
        flirtGraphic.animateToNext {
            flirtGraphic.delay = 0.5
            flirtGraphic.animation = "zoomOut"
            flirtGraphic.animateTo()
            
        }
        
        flirtGraphic.frame = CGRect(x: memberCollectionView.center.x, y: memberCollectionView.center.y, width: 300, height: 300)
        
        flirtGraphic.center = CGPoint(x: memberCollectionView.center.x - (self.frame.width / 20), y: memberCollectionView.center.y - (self.frame.width / 15))
        
        memberCollectionView.addSubview(flirtGraphic)
    }
    
    @objc private func block(){
        
        APIService.sharedInstance.blockUser(member: selectedMember, view: memberCollectionView)
        fetchMembers()
        
    }
    
    
    
    @objc func showMenu(sender: UIImageView, member: Member?){
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
        
        let chatButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        chatButton.setImage(UIImage(named: "chat_icon")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        chatButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        chatButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        chatButton.layer.cornerRadius = 50
        chatButton.addTarget(self, action: #selector(showChat), for: .touchUpInside)
        
        buttons.append(chatButton)
        
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
        
        
        let senderCenter = CGPoint(x: memberCollectionView.center.x, y: memberCollectionView.center.y + (self.frame.height / 15))
        
        ALRadialMenu().setButtons(buttons: buttons).setRadius(radius: Double(memberCollectionView.frame.width / 3)).setAnimationOrigin(animationOrigin: senderCenter).setOverlayBackgroundColor(backgroundColor: Constants.Colors.NOIR_BLACK.withAlphaComponent(0.7)).presentInView(view: memberCollectionView)
        print(selectedMember.memberName!)
        
    }
    
    
    //AdMob ads
//    func showAd() {
//        if PFUser.current()?["adFree"] as? Bool == false {
//            if PFUser.current()?["membership"] as? String == "basic" {
//                if interstitial.isReady {
//                    interstitial.present(fromRootViewController: self.memberCollectionView)
//                } else {
//                    print("Ad wasn't ready")
//                }
//            }
//        } else {
//            print("User is Ad Free.")
//        }
//    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9770059916027069/7359406151")
        interstitial.delegate = self as? GADInterstitialDelegate
        interstitial.load(GADRequest())
        
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
//    func checkBadges(){
//
//        let installation = PFInstallation.current()
//
//        if installation?.badge != nil {
//            if installation?.badge != 0 {
//                let cell = self.menuBar.collectionView.cellForItem(at: IndexPath(item: 5, section: 0))
//
//                cell?.tintColor = Constants.Colors.NOIR_GREEN
//                // create a sound ID, in this case its the tweet sound.
//                let systemSoundID: SystemSoundID = SystemSoundID(SYSTEM_SOUND)
//
//                // to play sound
//                AudioServicesPlaySystemSound (systemSoundID)
//
//                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//            }
//
//        }
//
//    }
    
    
    
    func clearBadges() {
        
        let installation = PFInstallation.current()
        installation?.badge = 0
        installation?.saveInBackground { (success, error) -> Void in
            if success {
                UIApplication.shared.applicationIconBadgeNumber = (installation?.badge.hashValue)!
            }
            else {
                print("failed to clear badges")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return number of members
        
        
        return members?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = memberCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MemberCell
        
        
        cell.member = members?[indexPath.item]
        
        if (cell.member?.memberOnline) != nil && (cell.member?.memberOnline)! {
            
            if (cell.member?.echo) != nil && (cell.member?.echo)! {

                let color = CABasicAnimation(keyPath: "borderColor")
                color.fromValue = Constants.Colors.NOIR_MEMBER_BORDER_ONLINE
                color.toValue = Constants.Colors.NOIR_MEMBER_BORDER_ECHO
                color.duration = 1
                color.autoreverses = true
                color.repeatCount = .infinity
                color.isRemovedOnCompletion = false
                
                cell.ProfilePics.layer.borderWidth = 3
                cell.ProfilePics.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_ONLINE
                cell.ProfilePics.layer.add(color, forKey: "borderColor")

                
            } else {
                cell.ProfilePics.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_ONLINE
            }
        } else {
            cell.ProfilePics.layer.borderColor = Constants.Colors.NOIR_MEMBER_BORDER_OFFLINE
        }
        
//        cell.ProfilePics.addGestureRecognizer(tapGesture)
        
        
      return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! MemberCell

//        displayedUserID = cell.userID!
        selectedMember = (members?[indexPath.item])!
        
        //geocoding block
        if let mLat = selectedMember.mLat {
            if let mLong = selectedMember.mLong {
                let geoCoder = CLGeocoder()
                let mlocation = CLLocation(latitude: mLat, longitude: mLong)
                var placeMark: CLPlacemark!
                geoCoder.reverseGeocodeLocation(mlocation, completionHandler: { (placemarks, error) -> Void in
                    
                    if error != nil {
                        print(error!)
                    } else {
                        placeMark = placemarks?[0]
                        
                        // Address dictionary
                        //print(placeMark.addressDictionary as Any)
                        var city = ""
                        var state = ""
                        var country = ""
                        
                        if placeMark.addressDictionary!["City"] != nil {
                            city = placeMark.addressDictionary!["City"] as! String
                            //                                                    print(city)
                        }
                        
                        // Country
                        if placeMark.addressDictionary!["State"] != nil {
                            state = placeMark.addressDictionary!["State"] as! String
                            //                                                   print(state)
                        }
                        
                        if placeMark.addressDictionary!["Country"] != nil {
                            country = placeMark.addressDictionary!["Country"] as! String
                            //                                                    print(country)
                        }
                        
                        let mcurrentLocation = (city) + ", " + (state)  + " " + (country)
                        
                        //                                                    print(currentLocation)
                        
                        self.selectedMember.location = mcurrentLocation as String
                    }
                    
                })
            }
            
        }
        
        showMenu(sender: cell.ProfilePics, member: selectedMember)

    }
    
}
