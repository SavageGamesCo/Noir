//
//  GADViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

class GADViewController: UIViewController, UIAlertViewDelegate {

//    @IBOutlet var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    @IBAction func button(_ sender: Any) {
        
        showAd()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
        createAndLoadInterstitial()
        
        
        
        
        
    }
    
    func showAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    fileprivate func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-9770059916027069/7359406151")
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
