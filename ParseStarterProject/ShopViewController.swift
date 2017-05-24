//
//  ShopViewController.swift
//  Noir
//
//  Created by Lynx on 5/24/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import UIKit
import StoreKit
import Parse

class ShopViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var AdFreeButton: UIButton!
    @IBOutlet weak var OneMonthButton: UIButton!
    @IBOutlet weak var ThreeMonthButton: UIButton!
    @IBOutlet weak var OneYearButton: UIButton!
    @IBOutlet weak var GoFundMeButton: UIButton!
    
    var list = [SKProduct]()
    var prod = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        
        let myProduct = response.products
        
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        
        AdFreeButton.isEnabled = true
        OneMonthButton.isEnabled = true
        ThreeMonthButton.isEnabled = true
        OneYearButton.isEnabled = true
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "comsavagecodeNoirAdRemoval":
                
                print("Remove Ads")
                
                removeAds()
                
                break
            case "comsavagecodeNoirOneMonth":
                
                print("Added one month subscription")
                
                subscriptions(type: "oneMonth")
                
                break
            case "comsavagecodeNoirThreeMonths":
                
                print("Added three month subscription")
                
                subscriptions(type: "threeMonth")
                
                break
            case "comsavagecodeNoirOneYear":
                
                print("Added one year subscription")
                
                subscriptions(type: "oneYear")
                
                break
            default:
                
                print("iAp Not Found")
                
                break
            }
            
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock iap here")
                print(prod.productIdentifier)
                
                let prodID = prod.productIdentifier
                switch prodID {
                case "comsavagecodeNoirAdRemoval":
                    
                    print("Remove Ads")
                    
                    removeAds()
                    
                    break
                case "comsavagecodeNoirOneMonth":
                    
                    print("Added one month subscription")
                    
                    subscriptions(type: "oneMonth")
                    
                    break
                case "comsavagecodeNoirThreeMonths":
                    
                    print("Added three month subscription")
                    
                    subscriptions(type: "threeMonth")
                    
                    break
                case "comsavagecodeNoirOneYear":
                    
                    print("Added one year subscription")
                    
                    subscriptions(type: "oneYear")
                    
                    break
                default:
                    
                    print("iAp Not Found")
                    
                    break

                }
                queue.finishTransaction(trans)
                break
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                
                break
            }
        }
        
    }
    
    
    @IBAction func AdFreeBuy(_ sender: Any) {
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "comsavagecodeNoirAdRemoval") {
                prod = product
                buyProduct()
            }
        }
        
    }
    
    @IBAction func OneMonthBuy(_ sender: Any) {
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "comsavagecodeNoirOneMonth") {
                prod = product
                buyProduct()
            }
        }
        
    }
    
    @IBAction func ThreeMonthBuy(_ sender: Any) {
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "comsavagecodeNoirThreeMonths") {
                prod = product
                buyProduct()
            }
        }
        
    }

    @IBAction func OneYearBuy(_ sender: Any) {
        
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "comsavagecodeNoirOneYear") {
                prod = product
                buyProduct()
            }
        }
        
    }
    
    @IBAction func GoFundMeVisit(_ sender: Any) {
        
        donate()
        
    }
    
    func buyProduct() {
    
        print("buy" + prod.productIdentifier)
        
        let pay = SKPayment(product: prod)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AdFreeButton.isEnabled = false
        OneYearButton.isEnabled = false
        OneMonthButton.isEnabled = false
        ThreeMonthButton.isEnabled = false
        
        if(SKPaymentQueue.canMakePayments()) {
            print("iap inabled")
            
            let productID: NSSet = NSSet(objects: "comsavagecodeNoirAdRemoval", "comsavagecodeNoirOneMonth", "comsavagecodeNoirThreeMonths", "comsavagecodeNoirOneYear")
            
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            
            request.delegate = self
            
            request.start()
            
        } else {
            
            print("please enable iap")
            
        }

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
        //end function for donate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
