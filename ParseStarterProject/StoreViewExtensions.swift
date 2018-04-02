//
//  StoreViewExtensions.swift
//  Noir
//
//  Created by Lynx on 4/2/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import Parse

extension StoreViewController {
    
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
        
        if result.restoreFailedPurchases.count > 0 {
            print("restore failed \(result.restoreFailedPurchases))")
            
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error, contact support")
        } else if result.restoredPurchases.count > 0 {
            
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
