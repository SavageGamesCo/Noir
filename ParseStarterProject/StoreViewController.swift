//
//  StoreViewController.swift
//  Noir
//
//  Created by Lynx on 3/29/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import Parse

private let reuseIdentifier = "Cell"
private let adFreeCellID = "adFreeCellID"
private let oneMonthCellID = "oneMonthCellID"
private let threeMonthCellID = "threeMonthCellID"
private let oneYearCellID = "oneYearCellID"
private let restoreCellID = "restoreCellID"

enum ShopRegisteredPurchase : String {
    case AdFree = "AdRemoval"
    case OneMonth = "OneMonth"
    case ThreeMonths = "ThreeMonths"
    case OneYear = "OneYear"
}

class StoreViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    let termsText = "This subscription is valid for 30 days, 90 days or 1 year, depending on the type of subscription you have selected. Payment will be charged to your iTunes Account at the time of  confirmation of your purchase. Your subscription will automatically renew unless auto-renew is turned off at least 24-hours before the end of the current subscription period. Your account will be charged the price listed at the top of this screen for renewal within 24-hours prior to the end of the current subscription period. Subscriptions may be managed and auto-renewal may be turned off by going to the Account Settings screen in the Apple App Store on your device after purchase. No cancellation of the current subscription allowed during the active subscription period. Please see the EULA & Terms of Service along with the Privacy Policy in your Profile Update screen. You may view the Privacy Policy online at http://noir.savage-code.com/#privacy"
    
    let adFreeText = "This one time purchase will enable your account to use Noir ad free. No more banner ads within the app and no more fullscreen ads! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    let oneMonthText = "Monthly Recurring Membership (AUTO-RENEWING)! With your monthly membership you gain unlimited global members, unlimited local members w/ increased radius, unlimited favorites, unlimited flirts and an increased message limit. Increased Echo Long Range distance to 20+ miles! Increased Echo Hits! Only paid members can send images in chat! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    let threeMonthText = "Save $2 per month on a 3 Month Recurring Membership (AUTO-RENEWING)! With your monthly membership you gain unlimited global members, unlimited local members w/ increased radius, unlimited favorites, unlimited flirts and an increased message limit. Increased Echo Long Range distance to 20+ miles! Increased Echo Hits! Only paid members can send images in chat! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    let oneYearText = "The ultimate savings! Save over $3 per month on a 1 Year Recurring Membership (AUTO-RENEWING)! With your monthly membership you gain unlimited global members, unlimited local members w/ increased radius, unlimited favorites, unlimited flirts and an increased message limit. Increased Echo Long Range distance to 20+ miles! Increased Echo Hits! Only paid members can send images in chat! REQUIRES LOGOUT & LOGIN AFTER PURCHASE"
    
    let restoreText = "If you switched phones or deleted the Noir Application, tap restor to restore your Noir purchases. REQUIRES LOGOUT & LOGIN AFTER RESTORE"
    
    let bundleID = "comsavagecodeNoir"
    
    var AdFree = ShopRegisteredPurchase.AdFree
    var OneMonth = ShopRegisteredPurchase.OneMonth
    var ThreeMonths = ShopRegisteredPurchase.ThreeMonths
    var OneYear = ShopRegisteredPurchase.OneYear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = .init(top: 5, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        
        self.collectionView!.setCollectionViewLayout(layout, animated: true)
        self.collectionView!.register(StoreItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.allowsSelection = true
        
        navigationController?.navigationItem.leftBarButtonItem?.tintColor = Constants.Colors.NOIR_YELLOW
        navigationController?.navigationItem.backBarButtonItem?.tintColor = Constants.Colors.NOIR_YELLOW
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 4
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
            cell.purchaseButton.addTarget(self, action: #selector(AdFreeBuy(_:)), for: .touchUpInside)
            
            
            break
        case 1:
            
            if indexPath.item == 0 {
                cell.titleLabel.text = "One Month Membership"
                cell.priceLabel.text = "$7.99"
                cell.itemTextField.text = oneMonthText
                cell.purchaseButton.setTitle("SUBSCRIBE", for: .normal)
                cell.purchaseButton.addTarget(self, action: #selector(OneMonthBuy(_:)), for: .touchUpInside)
                
                
            } else if indexPath.item == 1 {
                cell.titleLabel.text = "Three Month Membership"
                cell.priceLabel.text = "$17.49"
                cell.itemTextField.text = threeMonthText
                cell.purchaseButton.setTitle("SUBSCRIBE", for: .normal)
                cell.purchaseButton.addTarget(self, action: #selector(ThreeMonthBuy(_:)), for: .touchUpInside)
                
                
                
            } else if indexPath.item == 2 {
                cell.titleLabel.text = "One Year Membership"
                cell.priceLabel.text = "$58.99"
                cell.itemTextField.text = oneYearText
                cell.purchaseButton.setTitle("SUBSCRIBE", for: .normal)
                cell.purchaseButton.addTarget(self, action: #selector(OneYearBuy(_:)), for: .touchUpInside)
                
                
            }
            
            break
        case 2:
            cell.titleLabel.text = "Restore Purchases"
            cell.priceLabel.text = "$0.00"
            cell.itemTextField.text = restoreText
            cell.purchaseButton.setTitle("RESTORE", for: .normal)
            cell.purchaseButton.addTarget(self, action: #selector(RestorePurchases(_:)), for: .touchUpInside)
            
            
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
    
    
    func AdFreeBuy(_ sender: Any) {
        
        purchase(purchase: AdFree)
        
    }
    
    func OneMonthBuy(_ sender: Any) {
        
        purchase(purchase: OneMonth)
        
    }
    
    func ThreeMonthBuy(_ sender: Any) {
        
        purchase(purchase: ThreeMonths)
        
    }
    
    func OneYearBuy(_ sender: Any) {
        
        purchase(purchase: OneYear)
        
    }
    
    func RestorePurchases(_ sender: Any) {
        
        restorePurchase()
        
    }
    
    func Donations(_ sender: Any) {
        
        donate()
        
    }
    
    func getInfo(purchase : ShopRegisteredPurchase) {
        
        ShopNetworkActivityIndiciatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.retrieveProductsInfo([bundleID + purchase.rawValue], completion: {
            result in
            
            ShopNetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            
        })
        
        
        
    }
    
    func purchase(purchase : ShopRegisteredPurchase) {
        
        ShopNetworkActivityIndiciatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.purchaseProduct(bundleID + purchase.rawValue, completion: {
            
            result in
            
            ShopNetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            if case .success(let product) = result {
                
                if product.productId == self.bundleID + self.AdFree.rawValue {
                    self.removeAds()
                } else if product.productId == self.bundleID + self.OneMonth.rawValue {
                    
                    self.subscriptions(type: "oneMonth")
                } else if product.productId == self.bundleID + self.ThreeMonths.rawValue {
                    
                    self.subscriptions(type: "threeMonth")
                } else if product.productId == self.bundleID + self.OneYear.rawValue {
                    
                    self.subscriptions(type: "oneYear")
                }
                
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
                self.showAlert(alert: self.alertPurchaseResult(result: result))
            }
        })
        
    }
    
    func restorePurchase(){
        ShopNetworkActivityIndiciatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, completion: {
            
            result in
            
            ShopNetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            for product in result.restoredPurchases {
                
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
            }
            
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
            
        })
    }
    
    func verifyReceipt() {
        
        ShopNetworkActivityIndiciatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: ReceiptValidator.self as! ReceiptValidator, password: ShopsharedSecret, completion: {
            result in
            
            ShopNetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            self.showAlert(alert: self.alertForVerifiedReceipt(result: result))
            
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    
                    self.refreshReceipt()
                }
                
            }
            
        })
        
    }
    
    func verifyPurchase(product : ShopRegisteredPurchase) {
        
        ShopNetworkActivityIndiciatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: ReceiptValidator.self as! ReceiptValidator, password: ShopsharedSecret, completion: {
            
            result in
            
            ShopNetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            switch result {
                
            case .success(let receipt):
                
                let productID = self.bundleID + product.rawValue
                
                if product == .OneMonth {
                    let purchaseResult = SwiftyStoreKit.verifySubscription(type: .autoRenewable, productId: productID, inReceipt: receipt, validUntil: Date())
                    
                    self.showAlert(alert: self.alertForVerifySubscription(result: purchaseResult))
                } else  {
                    let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                    
                    self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
                }
                
            case .error(let error):
                
                self.showAlert(alert: self.alertForVerifiedReceipt(result: result))
                if case .noReceiptData = error{
                    self.refreshReceipt()
                }
                
            }
            
        })
        
    }
    
    func refreshReceipt() {
        
        SwiftyStoreKit.verifyReceipt(using: ReceiptValidator.self as! ReceiptValidator, completion: {
            
            result in
            
            DispatchQueue.main.async {
                
            }
            
        })
    }
    
    func removeAds() {
        
        PFUser.current()?["adFree"] = true
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                print("This account is now ad free")
                
                
            }
        })
        
    }
    
    func subscriptions(type: String) {
        
        PFUser.current()?["membership"] = type
        
        PFUser.current()?["globalLimit"] = 1000
        
        PFUser.current()?["withinDistance"] = 100
        
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                print("This account is now a \(type) member!")
                
            }
            
            
        })
    }
    
    func donate(){
        
        PFUser.current()?["GFMVisit"] = "YES"
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                print("This user has gone to the gofund me page")
                
            }
        })
        
        UIApplication.shared.openURL(NSURL(string: "https://www.indiegogo.com/projects/noir-mobile-dating-for-gay-people-of-color-apps/x/16898469#/")! as URL)

    }

}

class SectionHeader: UICollectionReusableView {
    weak var sectionHeaderlabel: UILabel!
}


var ShopsharedSecret = "910acba900c84a9391fac684a407139e"

class ShopNetworkActivityIndiciatorManager: NSObject {
    
    private static var loadingCount = 0
    
    class func NetworkOperationStarted() {
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
        
        loadingCount += 1
    }
    
    class func NetworkOperationFinished(){
        
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        }
        
    }
    
}
