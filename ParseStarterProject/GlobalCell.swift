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
    
    let cellID = "cellID"
    
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
    
    func refreshing(){

        self.memberCollectionView.reloadData()

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
        
        
        
      return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! MemberCell
        
        displayedUserID = cell.userID!
        
//        performSegue(withIdentifier: "toUserDetails", sender: self)
        
    }
    
}
