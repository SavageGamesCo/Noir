/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit

import Parse

import ParseLiveQuery

import Firebase

import GoogleMobileAds

import UserNotifications


// If you want to use any of the UI components, uncomment this line
// import ParseUI

var badge = Int()

var imagesSent = 0

var userListMessage = false
var echoMessage = false
var echoMessageShort = false
var echoMessageLong = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let navBarColor = Constants.Colors.NOIR_GREY_MEDIUM
    let statusBarBackgroundColor = Constants.Colors.NOIR_GREY_DARK
    
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //a layout for the collection view must be specified
        let layout = UICollectionViewFlowLayout()
        
        
        //create the controller object to be the initial view
        let mainViewController = MainViewController(collectionViewLayout: layout)
        
        //add the initial view to the window, in this case as a navigation view controller beginning root view controller
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
//        window?.rootViewController = LoginController()
        
        //changing the color of the navigation bar
        UINavigationBar.appearance().barTintColor = navBarColor
        //changing the status bar text style color
        application.statusBarStyle = .lightContent
        
        
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = statusBarBackgroundColor
        
        window?.addSubview(statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "V:|[v0(20)]|", views: statusBarBackgroundView)
        
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "7XSgD4z6lpoNGGCbQEoi5MxIgDxBnopMmNYw92cq"
            ParseMutableClientConfiguration.clientKey = "aANqvWmGX0JFvNuy0qQ887TT5WRBtYbeEB8D4ink"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
        })
        
        Parse.initialize(with: parseConfiguration)


        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************

        //PFUser.enableAutomaticUser()

        let defaultACL = PFACL();

        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true

        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)

        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            /*
            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpened(launchOptions: launchOptions)
            }
 */
        }

        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            DispatchQueue.main.async {
                application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound , .badge , .alert], categories: nil))

            application.registerForRemoteNotifications()
            }
            
        }
        
        
        
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9770059916027069~1452473359")
        return true
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground()
    }
    
    func  applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        clearBadges()
    }
    
    func applicationWillBecomeActive(_ application: UIApplication) {
        clearBadges()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }

//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        PFPush.handle(userInfo)
//        if application.applicationState == UIApplicationState.inactive {
//            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
//        }
//    }

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
     func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
         if application.applicationState == UIApplicationState.inactive {
             PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
         }
     }
    
    func clearBadges() {
//        badge = 0
//        UIApplication.shared.applicationIconBadgeNumber = badge
//        let installation = PFInstallation.current()
//        installation?.badge = 0
//        installation?.saveInBackground { (success, error) -> Void in
//            if success {
//                print("cleared badges")
//                UIApplication.shared.applicationIconBadgeNumber = 0
//            }
//            else {
//                print("failed to clear badges")
//            }
//        }
    }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
}
