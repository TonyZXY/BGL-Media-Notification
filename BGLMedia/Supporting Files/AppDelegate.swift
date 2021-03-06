//
//  AppDelegate.swift
//  news app for blockchain
//
//  Created by Sheng Li on 12/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

 
import UIKit
import UserNotifications
import SwiftyJSON
import Alamofire
import RealmSwift
import StoreKit
import SwiftKeychainWrapper
import Darwin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {   
    
    var window: UIWindow?
    
    var getDeviceToken:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "getDeviceToken")
        }
    }
    
    var email:String{
        get{
//            return UserDefaults.standard.string(forKey: "UserEmail") ?? "null"
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
        }
    }
    
    var certificateToken:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
        }
    }
    
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var deviceToken:String{
        get{
            return UserDefaults.standard.string(forKey: "UserToken") ?? "null"
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        

        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 9,
            //old 2
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 9) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Person object stored in the Realm file
                    //                    migration.enumerateObjects(ofType: Person.className()) { oldObject, newObject in
                    //                        // combine name fields into a single field
                    //                        let firstName = oldObject!["firstName"] as! String
                    //                        let lastName = oldObject!["lastName"] as! String
                    //                        newObject!["fullName"] = "\(firstName) \(lastName)"
                    //                    }
                }
        })
        _ = try! Realm()
        
       
        
        
        
        var appOpenCount = UserDefaults.standard.integer(forKey: "APP_OPENED_COUNT")
        if appOpenCount > 100 {
            UserDefaults.standard.set(1, forKey: "APP_OPENED_COUNT")
        } else{
            appOpenCount += 1
        }
        
        UserDefaults.standard.set(appOpenCount, forKey: "APP_OPENED_COUNT")
        appOpenCount = UserDefaults.standard.integer(forKey: "APP_OPENED_COUNT")
        print("\(appOpenCount) is the times of open time")
        switch appOpenCount {
        case 10,50:
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        case _ where appOpenCount%100 == 0 :
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
            UserDefaults.standard.set(0, forKey: "APP_OPENED_COUNT")
        default:
            break;
        }
        
        
//        application.statusBarStyle = .lightContent
//        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = ThemeColor().darkBlackColor()
//        UITabBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().tintColor = ThemeColor().navigationBarColor()
        UINavigationBar.appearance().barTintColor = ThemeColor().navigationBarColor()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().back
        

//        let backItem = UIBarButtonItem()
//        backItem.title = textValue(name: "back_button")
//        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
//        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
//        UINavigationItem().backBarButtonItem = backItem
       
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ (granted, error) in
             }// user reaction handling
        
//        print("granted:\(granted)")
        UIApplication.shared.registerForRemoteNotifications()
        
//        // modified
//        if !UserDefaults.standard.bool(forKey: "flashSwitch") && !loginStatus{
//            UIApplication.shared.unregisterForRemoteNotifications()
//        }
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let uploadAssetsToServer = UserDefaults.standard.bool(forKey: "UploadAssetsToServer")
        
        
        
        if launchedBefore{
//            set flag to false for debugging purpose
//            UserDefaults.standard.set(false, forKey: "launchedBefore")
//            window?.rootViewController = LaunchScreenViewController()
//            window?.makeKeyAndVisible()
            
            
            
//            if UserDefaults.standard.bool(forKey: "isLoggedIn"){
                window = UIWindow(frame:UIScreen.main.bounds)
//                let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
                window?.rootViewController = LaunchScreenViewController()
                window?.makeKeyAndVisible()
//            }else{
//                //User is not logged in
//                print("User is not logged in")
//            }
//
            
            
        
        } else{
            //First time launch
            window = UIWindow(frame:UIScreen.main.bounds)
            let mainViewController = LaunchScreenViewController()
            window?.rootViewController = mainViewController
            window?.makeKeyAndVisible()
//            SetDataResult().writeJsonExchange()
//            SetDataResult().writeMarketCapCoinList()
//            URLServices.fetchInstance.getCoinList()
            UserDefaults.standard.set(true, forKey: "flashSwitch")
            UserDefaults.standard.set(true, forKey: "priceSwitch")
            UserDefaults.standard.set("AUD", forKey: "defaultCurrency")
            UserDefaults.standard.set("EN", forKey: "defaultLanguage")
            UserDefaults.standard.set(false, forKey: "buildInterest")
            UserDefaults.standard.set(false, forKey: "SendDeviceToken")
            UserDefaults.standard.set(false, forKey: "getDeviceToken")
            UserDefaults.standard.set(false, forKey: "changeAlertStatus")
            UserDefaults.standard.set(false, forKey: "assetsLoad")
            UserDefaults.standard.set("null", forKey: "UserEmail")
            UserDefaults.standard.set("null", forKey: "CertificateToken")
            UserDefaults.standard.set("null", forKey: "UserToken")
            KeychainWrapper.standard.set("null", forKey: "Email")
        }
        
        if !uploadAssetsToServer{
            if loginStatus{
                let realm = try! Realm()
                if realm.objects(Transactions.self).count != 0{
                    URLServices.fetchInstance.sendAssets(){success in
                        if success{
                            try! realm.write {
                                realm.delete(realm.objects(Transactions.self))
                            }
                            UserDefaults.standard.set(true, forKey: "UploadAssetsToServer")
                        }
                    }
                }
            }
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let notification = response.notification.request.content.userInfo as? [String: AnyObject] {
            let message = parseRemoteNotification(notification: notification)
            print(message as Any)
        }
        completionHandler()
    }
    
    private func parseRemoteNotification(notification: [String: AnyObject])->String? {
        if let aps = notification["aps"] as? [String: AnyObject]{
            let alert = aps["alert"] as? String
            return alert
        }
        
        return nil
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("register to open notification")
        let deviceTokenString = deviceToken.reduce("",{$0 + String(format: "%02X",$1)})
        print("token:\(deviceTokenString)")
        
        
        UserDefaults.standard.set(deviceTokenString, forKey: "UserToken")
        UserDefaults.standard.set(true, forKey: "getDeviceToken")
        
        if self.loginStatus{
//            if !self.sendDeviceTokenStatus{
                let sendDeviceTokenParameter = ["email":self.email,"token":self.certificateToken,"deviceToken":deviceTokenString]
                URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","addIOSDevice"], httpMethod: "POST", parameters: sendDeviceTokenParameter, completion: { (response, success) in
                    if success{
                        UserDefaults.standard.set(true, forKey: "SendDeviceToken")
                        print(response)
                    }
                })
//            }
        }
        else {
            // modified
            //print(sendDeviceTokenStatus)
            //if !sendDeviceTokenStatus {
                //send device token to unknown user table
                let sendDeviceTokenParameter = ["deviceToken": deviceTokenString]
                //print(deviceTokenString)
                URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","IOSNewsFlash"], httpMethod: "POST", parameters: sendDeviceTokenParameter, completion: {(res, success) in
                    if success {
                        print("device token has been sent : " + deviceTokenString)
                        UserDefaults.standard.set(true, forKey: "SendDeviceToken")
                        print(res)
                    }
                })
            //}
        }
    }
    
//    var sendDeviceTokenStatus:Bool{
//        get{
//            return UserDefaults.standard.bool(forKey: "SendDeviceToken")
//        }
//    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail to open notification")
        
        //handle failure
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UserDefaults.standard.set(false, forKey: "NotificationSetting")
        print("success to open notification")
//        print("\(userInfo)")
//        let aps = userInfo["aps"] as! [String: Any]
//        print("\(aps)")
    }
    

    func applicationDidBecomeActive(_ application: UIApplication) {
//       UIApplication.shared.applicationIconBadgeNumber = 0
////        let email = UserDefaults.standard.string(forKey: "UserEmail") ?? "null"
////        let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
////        let deviceToken = UserDefaults.standard.string(forKey: "UserToken") ?? "null"
//
//        if loginStatus{
//            if getDeviceToken{
//                if self.email != "null" && self.certificateToken != "null" &&  self.deviceToken != "null"{
//                    URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","receivedNotification"], httpMethod: "POST", parameters: ["email":email,"token":certificateToken,"deviceToken":deviceToken]) { (response, success) in
//                        if success{
//                            print(response)
//                        }
//                    }
//                }
//            }
//        } 
    }
//
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"refreshNotificationStatus"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"refreshInternalBadge"), object: nil)
    }
}

//extension UINavigationItem{
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//        let backItem = UIBarButtonItem()
//        backItem.title = textValue(name: "back_button")
//        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
//        /*Changing color*/
//        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
//        self.backBarButtonItem = backItem
//    }
//
////    func changeBackButton(){
////        let backItem = UIBarButtonItem()
////        backItem.title = textValue(name: "back_button")
////        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
////        /*Changing color*/
////        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
////        self.backBarButtonItem = backItem
////    }
//
//    class var customNavBar : UINavigationBar{
//        let backItem = UIBarButtonItem()
//        backItem.title = textValue(name: "back_button")
//        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
//                /*Changing color*/
//        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
//        self.backBarButtonItem = backItem
//    }
//
//}
