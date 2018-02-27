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

class GlobalCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var members: [Member]?
    
    var online = [String]()
    var blocked = [String]()
    var mainViewController: MainViewController?
    var interstitial: GADInterstitial!
    //Constants

    let refreshControl = UIRefreshControl()
    
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
    
    let cellID = "cellID"
    
//    var tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMenu(sender:,member:)))
    
    override func setupViews() {
        
        backgroundColor = Constants.Colors.NOIR_BACKGROUND
        
        addSubview(memberCollectionView)
        
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
    
        fetchMembers()
        
        var timer: Timer!
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(refreshing), userInfo: nil, repeats: true)
        

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
            
            
        }
    }
    
    var selectedMember = Member()
    
    func refreshing(){
        self.memberCollectionView.reloadData()

    }
    
    @objc private func showStats(){
        detailsView.showDetails(member: selectedMember)
    }
    @objc private func showGallery(){
        settingsView.showSettings()
    }
    
    @objc private func showChat(){
        let layout = UICollectionViewFlowLayout()
        
        let controller = ChatController(collectionViewLayout: layout)
        
        controller.member = selectedMember
        
        self.window?.rootViewController?.present(controller, animated: true, completion: nil)
    }
    
    @objc private func favorite(){
        settingsView.showSettings()
    }
    
    @objc private func flirt(){
        settingsView.showSettings()
    }
    
    @objc private func block(){
        settingsView.showSettings()
    }
    
    
    
    @objc func showMenu(sender: UIImageView, member: Member?){
        var buttons = [ALRadialMenuButton]()
       
        let statsButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        statsButton.setImage(UIImage(named: "newspaper-7")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
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
        chatButton.setImage(UIImage(named: "message-7")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        chatButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        chatButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        chatButton.layer.cornerRadius = 50
        chatButton.addTarget(self, action: #selector(showChat), for: .touchUpInside)
        
        buttons.append(chatButton)
        
        let blockButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blockButton.setImage(UIImage(named: "emoticon-sad-7")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        blockButton.backgroundColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_COLOR
        blockButton.tintColor = Constants.Colors.NOIR_RADIAL_MENU_BUTTON_TINT_COLOR
        blockButton.layer.cornerRadius = 50
        blockButton.addTarget(self, action: #selector(block), for: .touchUpInside)
        
        buttons.append(blockButton)
        
        let flirtButton = ALRadialMenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        flirtButton.setImage(UIImage(named: "flirts_icon")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
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
                
//                CATransaction.begin()
//                CATransaction.setAnimationDuration(2.0)
//                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
//
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
                
//                CATransaction.commit()
                
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

        displayedUserID = cell.userID!
        selectedMember = (members?[indexPath.item])!
        showMenu(sender: cell.ProfilePics, member: selectedMember)
        print(123)
//        performSegue(withIdentifier: "toUserDetails", sender: self)

    }
    
}
