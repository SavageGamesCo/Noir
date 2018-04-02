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
    
    let termsText = "This subscription is valid for 30 days, 90 days or 1 year, depending on the type of subscription you have selected. Payment will be charged to your iTunes Account at the time of  confirmation of your purchase. Your subscription will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current subscription period. Your account will be charged the price listed at the top of this screen for renewal within 24-hours prior to the end of the current subscription period. Subscriptions may be managed and auto-renewal may be turned off by going to the Account Settings screen in the Apple App Store on your device after purchase. No cancellation of the current subscription allowed during the active subscription period. Please see the EULA & Terms of Service along with the Privacy Policy in your Profile Update screen. You may alview the Privacy Policy online at http://noir.savage-code.com/#privacy"
    
    let adFreeText = ""
    let oneMonthText = ""
    let threeMonthText = ""
    let oneYearText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = .init(top: 5, left: 5, bottom: 10, right: 5)
        layout.scrollDirection = .vertical
        
        self.collectionView!.setCollectionViewLayout(layout, animated: true)
        self.collectionView!.register(StoreItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        let section = indexPath.section
        let approximateWidthOfContent = self.view.frame.width
        
        let size = CGSize(width: approximateWidthOfContent, height: 1000)
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        
        switch section {
        case 0:
            
            let estimatedFrame = NSString(string: adFreeText ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
        case 1:
            //inner switch for memberships
            switch indexPath.item {
            case 0:
                
                let estimatedFrame = NSString(string: oneMonthText ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                
                return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
            case 1:
                
                let estimatedFrame = NSString(string: threeMonthText ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                
                return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
            case 2:
                
                let estimatedFrame = NSString(string: oneYearText ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                
                return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
            default:
                return CGSize(width: 0, height: 0)
            }
            //end of inner switch for memberships
        case 2:
            let approximateWidthOfContent = self.view.frame.width
            
            return CGSize(width: approximateWidthOfContent, height: 75)
            
        case 3:
            
            let estimatedFrame = NSString(string: termsText ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
            
        default:
            return CGSize(width: 100, height: 25)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        
        switch section {
        case 0:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "One Time Purchase", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
                return sectionHeader
            }
            
            break
        case 1:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Memberships", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
                return sectionHeader
            }
            break
        case 2:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Restore Purchase", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
                return sectionHeader
            }
            break
        case 3:
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Terms of Use/Purchase", for: indexPath) as? SectionHeader{
                sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
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
        
        switch section {
        case 0:
            
            break
        case 1:
            
            break
        case 2:
            
            break
        case 3:
            
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







