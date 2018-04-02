//
//  StoreViewController.swift
//  Noir
//
//  Created by Lynx on 3/29/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class StoreViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    let termsText = "This subscription is valid for 30 days, 90 days or 1 year, depending on the type of subscription you have selected. Payment will be charged to your iTunes Account at the time of  confirmation of your purchase. Your subscription will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current subscription period. Your account will be charged the price listed at the top of this screen for renewal within 24-hours prior to the end of the current subscription period. Subscriptions may be managed and auto-renewal may be turned off by going to the Account Settings screen in the Apple App Store on your device after purchase. No cancellation of the current subscription allowed during the active subscription period. Please see the EULA & Terms of Service along with the Privacy Policy in your Profile Update screen. You may view the Privacy Policy online at http://noir.savage-code.com/#privacy"
    
    let adFreeText = "This one time purchase will enable your account to use Noir ad free. No more banner ads within the app and no more fullscreen ads! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    let oneMonthText = "Monthly Recurring Membership (AUTO-RENEWING)! With your monthly membership you gain unlimited global members, unlimited local members w/ increased radius, unlimited favorites, unlimited flirts and an increased message limit. Increased Echo Long Range distance to 20+ miles! Increased Echo Hits! Only paid members can send images in chat! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    let threeMonthText = "Save $2 per month on a 3 Month Recurring Membership (AUTO-RENEWING)! With your monthly membership you gain unlimited global members, unlimited local members w/ increased radius, unlimited favorites, unlimited flirts and an increased message limit. Increased Echo Long Range distance to 20+ miles! Increased Echo Hits! Only paid members can send images in chat! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    let oneYearText = "The ultimate savings! Save over $3 per month on a 1 Year Recurring Membership (AUTO-RENEWING)! With your monthly membership you gain unlimited global members, unlimited local members w/ increased radius, unlimited favorites, unlimited flirts and an increased message limit. Increased Echo Long Range distance to 20+ miles! Increased Echo Hits! Only paid members can send images in chat! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    
    let restoreText = "If you switched phones or deleted the Noir Application, tap restor to restore your Noir purchases. REQUIRES LOGOUT & LOGIN AFTER RESTORE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = .init(top: 5, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        
        
        self.collectionView!.setCollectionViewLayout(layout, animated: true)
        self.collectionView!.register(StoreItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.allowsSelection = true
        
    
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 300, height: 25)
//    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        var items = Int()
        
        switch section {
        case 0:
            items = 1
            break
        case 1:
            items = 3
            break
        case 2:
            items = 1
            break
        case 3:
            items = 1
            break
        default:
            return 0
        }
        
        
        return items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height = CGFloat()
        
        switch indexPath.section {
        case 0:
            height = 120
            break
        case 1:
            height = 170
            break
        case 2:
            height = 95
            break
        case 3:
            height = 250
            break
        default:
            break
        }
        
       return CGSize(width: self.view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        
        switch section {
        case 0:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "OneTime", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "One Time Purchase"
                return sectionHeader
            }
            
            break
        case 1:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Memberships", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "Memberships"
                return sectionHeader
            }
            break
        case 2:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Restore", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "Restore Purchase"
                return sectionHeader
            }
            break
        case 3:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Terms", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "Terms of Use/Purchase"
                return sectionHeader
            }
            break
        default:
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoreItemCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        switch section {
        case 0:
            cell.titleLabel.text = "Noir: Ad-Free"
            cell.priceLabel.text = "$4.99"
            cell.itemTextField.text = adFreeText
            cell.purchaseButton.setTitle("BUY", for: .normal)
            
            
            break
        case 1:
            
            if indexPath.item == 0 {
                cell.titleLabel.text = "Noir: One Month Membership"
                cell.priceLabel.text = "$7.99"
                cell.itemTextField.text = oneMonthText
                cell.purchaseButton.setTitle("SUBSCRIBE", for: .normal)
                
                
            } else if indexPath.item == 1 {
                cell.titleLabel.text = "Noir: Three Month Membership"
                cell.priceLabel.text = "$17.49"
                cell.itemTextField.text = threeMonthText
                cell.purchaseButton.setTitle("SUBSCRIBE", for: .normal)
                
                
                
            } else if indexPath.item == 2 {
                cell.titleLabel.text = "Noir: One Year Membership"
                cell.priceLabel.text = "$58.99"
                cell.itemTextField.text = oneYearText
                cell.purchaseButton.setTitle("SUBSCRIBE", for: .normal)
                
                
            }
            
            break
        case 2:
            cell.purchaseButton.setTitle("Restore", for: .normal)
            
            cell.titleLabel.text = "Restore Purchase"
            cell.priceLabel.text = ""
            cell.itemTextField.text = restoreText
            
            
            break
        case 3:
            cell.titleLabel.text = "Terms of Use / Purchase"
            cell.priceLabel.text = ""
            cell.itemTextField.text = termsText
            cell.purchaseButton.isHidden = true

            break
        default:
            return cell
        }
        
        return cell
    }

}

class SectionHeader: UICollectionReusableView {
    weak var sectionHeaderlabel: UILabel!
}







