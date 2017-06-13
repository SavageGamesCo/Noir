//
//  ShopSwiftyViewController.swift
//  Noir
//
//  Created by Lynx on 5/24/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import Parse

enum RegisteredPurchase : String {
    case AdFree = "AdRemoval"
    case OneMonth = "OneMonth"
    case ThreeMonths = "ThreeMonths"
    case OneYear = "OneYear"
}

var sharedSecret = "910acba900c84a9391fac684a407139e"

class NetworkActivityIndiciatorManager: NSObject {
    
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

class ShopSwiftyViewController: UITableViewController {
    
    
    let bundleID = "comsavagecodeNoir"
    
    var AdFree = RegisteredPurchase.AdFree
    var OneMonth = RegisteredPurchase.OneMonth
    var ThreeMonths = RegisteredPurchase.ThreeMonths
    var OneYear = RegisteredPurchase.OneYear
    
    @IBOutlet weak var AdFreeButton: UIButton!
    @IBOutlet weak var OneMonthButton: UIButton!
    @IBOutlet weak var ThreeMonthButton: UIButton!
    @IBOutlet weak var OneYearButton: UIButton!
    
    @IBAction func AdFreeBuy(_ sender: Any) {
        
        purchase(purchase: AdFree)
        
    }
    
    @IBAction func OneMonthBuy(_ sender: Any) {
        
        purchase(purchase: OneMonth)
        
    }
    
    @IBAction func ThreeMonthBuy(_ sender: Any) {
        
        purchase(purchase: ThreeMonths)
        
    }
    
    @IBAction func OneYearBuy(_ sender: Any) {
        
        purchase(purchase: OneYear)
        
    }
    
    @IBAction func RestorePurchases(_ sender: Any) {
        
        restorePurchase()
        
    }
    
    @IBAction func Donations(_ sender: Any) {
        
        donate()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print(indexPath.section)
        print(indexPath.row)
        
        if indexPath.section == 0 && indexPath.row == 0 {
            print("ad free")
            purchase(purchase: AdFree)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            print("one month")
            purchase(purchase: OneMonth)
        } else if indexPath.section == 1 && indexPath.row == 1 {
            print("three month")
            purchase(purchase: ThreeMonths)
        } else if indexPath.section == 1 && indexPath.row == 2 {
            print("one year")
            purchase(purchase: OneYear)
        } else if indexPath.section == 2 && indexPath.row == 0 {
            print("restore")
            restorePurchase()
        }
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        
    }
    
    
    func getInfo(purchase : RegisteredPurchase) {
    
        NetworkActivityIndiciatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.retrieveProductsInfo([bundleID + purchase.rawValue], completion: {
            result in
            
            NetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            self.showAlert(alert: self.alertForProductRetrievalInfo(result: result))
            
        })
            
        
        
    }
    
    func purchase(purchase : RegisteredPurchase) {
    
        NetworkActivityIndiciatorManager.NetworkOperationStarted()
        
        SwiftyStoreKit.purchaseProduct(bundleID + purchase.rawValue, completion: {
        
            result in
            
            NetworkActivityIndiciatorManager.NetworkOperationFinished()
            
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
        NetworkActivityIndiciatorManager.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, completion: {
            
            result in
        
            NetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            for product in result.restoredProducts {
            
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                
            }
            
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
        
        })
    }
    
    func verifyReceipt() {
    
        NetworkActivityIndiciatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: ReceiptValidator.self as! ReceiptValidator, password: sharedSecret, completion: {
            result in
            
            NetworkActivityIndiciatorManager.NetworkOperationFinished()
            
            self.showAlert(alert: self.alertForVerifiedReceipt(result: result))
            
            if case .error(let error) = result {
                if case .noReceiptData = error {
                    
                    self.refreshReceipt()
                }
            
            }
        
        })
        
    }
    
    func verifyPurchase(product : RegisteredPurchase) {
    
        NetworkActivityIndiciatorManager.NetworkOperationStarted()
        SwiftyStoreKit.verifyReceipt(using: ReceiptValidator.self as! ReceiptValidator, password: sharedSecret, completion: {
            
            result in
            
            NetworkActivityIndiciatorManager.NetworkOperationFinished()
            
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
    
        SwiftyStoreKit.refreshReceipt(completion: {
        
            result in
            
            self.showAlert(alert: self.alertForRefreshReceipt(result: result))
            
        })
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func removeAds() {
        //function that sets the user account to be ad free
        PFUser.current()?["adFree"] = true
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                print("This account is now ad free")
                
                
            }
        })
        //end function for ad removal
        
    }
    
    func subscriptions(type: String) {
        //function to set the user account to a membership type, either one month, three month or one year
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
        //end function for subscription
    }
    
    func donate(){
        //function to send the user to the gofundme page so they can donate
        PFUser.current()?["GFMVisit"] = "YES"
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                print(error!)
            } else {
                
                print("This user has gone to the gofund me page")
                
            }
        })
        
//        UIApplication.shared.openURL(NSURL(string: "http://www.gofundme.com")! as URL)
        
        //end function for donate
    }

    
}

extension UITableViewController {
    
    func alertWithTitle(title: String, message: String) -> UIAlertController {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        return alert
    
    }
    
    func showAlert(alert : UIAlertController) {
        guard let _ = self.presentedViewController else {
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
    }
    
    func alertForProductRetrievalInfo(result : RetrieveResults) -> UIAlertController {
    
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        
        } else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could not retrieve product info", message: "Invalid Product Identifier: \(invalidProductID)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unkown Error. Please Contact Support"
            
            return alertWithTitle(title: "Could not retrieve product info", message: errorString)
        
        }
        
    }
    
    func alertPurchaseResult(result : PurchaseResult) -> UIAlertController {
        
        switch result {
        case .success(let product):
            print("Purchase Successful: \(product.productId)")
            
            return alertWithTitle(title: "Thank You!", message: "Purchase Completed")
            
        case .error(let error):
            print("Purchase Failed: \(error)")
            
            
            return alertWithTitle(title: "Purchase Failed", message: "Unable to make a purchase. Please check your network connection or try again later.")
            
        }
    
    }
    
    func alertForRestorePurchases(result : RestoreResults) -> UIAlertController {
        
        if result.restoreFailedProducts.count > 0 {
            print("restore failed \(result.restoreFailedProducts))")
            
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error, contact support")
        } else if result.restoredProducts.count > 0 {
            
            return alertWithTitle(title: "Purchases Restored", message: "All Purchases Restored")
        } else {
            
            return alertWithTitle(title: "Nothing to Restore", message: "You have no previous purchases")
        }
    }
    
    func alertForVerifiedReceipt(result : VerifyReceiptResult) -> UIAlertController {
    
        switch result {
        case .success( _):
            
            return alertWithTitle(title: "Verified Receipt", message: "Receipt verified")
        case . error(let error):
            
            return alertWithTitle(title: "Unable to Verify Receipt", message: "Unable to verify receipt, application will try to get a new one: \(error)")
        
        }
        
    }
    
    func alertForVerifySubscription(result : VerifySubscriptionResult) -> UIAlertController {
    
        switch result {
        
        case .purchased(let expiryDate):
            return alertWithTitle(title: "Membership Purchased", message: "Membership is valid until \(expiryDate). Please LogOut and Log back in to experience Noir with no restrictions and Ad-Free! See the Terms of Use/EULA and Privacy Policy in your settings at the bottom of the screen.")
        case .notPurchased:
            return alertWithTitle(title: "Membership Not Purchased", message: "You have not purchased this membership")
        case .expired(let expiryDate):
            
            PFUser.current()?["membership"] = "basic"
            
            PFUser.current()?.saveInBackground()
            
            return alertWithTitle(title: "Membership Expired", message: "Your membership expired \(expiryDate)")
        }
    
    }
    
    func alertForVerifyPurchase(result : VerifyPurchaseResult) -> UIAlertController {
        
        switch result {
            
        case .purchased:
            return alertWithTitle(title: "Ad Free Purchased", message: "Noir is now completely Ad Free! Please Logout and Log back in to Experience Noir Ad Free! See the Terms of Use/EULA and Privacy Policy in your settings at the bottom of the screen.")
        case .notPurchased:
            return alertWithTitle(title: "Ad Free is Not Purchased", message: "You have not purchased this feature")
        
        }
        
    }
    
    func alertForRefreshReceipt(result : RefreshReceiptResult) -> UIAlertController {
    
        switch result {
        case .success(let receiptData):
            return alertWithTitle(title: "Receipts Refreshed", message: "Your receipts for purchases have been refreshed \(receiptData)")
        case .error(let error):
            return alertWithTitle(title: "Unable to Refresh Receipts", message: "Receipt refresh has failed \(error)")
        
        }
        
    }
    
    
}
