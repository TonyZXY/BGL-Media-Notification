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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        application.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = ThemeColor().themeColor()
//        UITabBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().tintColor = ThemeColor().navigationBarColor()
        UINavigationBar.appearance().barTintColor = ThemeColor().navigationBarColor()
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
       
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ (granted, error) in
             }// user reaction handling
        
//        print("granted:\(granted)")
        UIApplication.shared.registerForRemoteNotifications()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
       

        if launchedBefore{
             URLServices.fetchInstance.getCoinList()
//            set flag to false for debugging purpose
//            UserDefaults.standard.set(false, forKey: "launchedBefore")
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn"){
                window = UIWindow(frame:UIScreen.main.bounds)
                let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
                window?.rootViewController = mainViewController
                window?.makeKeyAndVisible()
            }else{
                //User is not logged in
                print("User is not logged in")
            }
            
        } else{
            //First time launch
            window = UIWindow(frame:UIScreen.main.bounds)
            let mainViewController = OnBoardingUIPageViewController()
            window?.rootViewController = mainViewController
            window?.makeKeyAndVisible()
            
            SetDataResult().writeJsonExchange()
            SetDataResult().writeMarketCapCoinList()
            URLServices.fetchInstance.getCoinList()
            UserDefaults.standard.set(true, forKey: "flashSwitch")
            UserDefaults.standard.set(true, forKey: "priceSwitch")
            UserDefaults.standard.set("AUD", forKey: "defaultCurrency")
            UserDefaults.standard.set("CN", forKey: "defaultLanguage")
            UserDefaults.standard.set(false, forKey: "buildInterest")
            UserDefaults.standard.set(false, forKey: "SendDeviceToken")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let notification = response.notification.request.content.userInfo as? [String: AnyObject] {
            let message = parseRemoteNotification(notification: notification)
//            print(message as Any)
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
        
//        let deviceTokenJson: [String: Any] = [
//            "deviceID": deviceTokenString,
//            "notification": true
//        ]
//        Alamofire.request("http://10.10.6.18:3030/deviceManage/addIOSDevice", method: .post, parameters: deviceTokenJson, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).validate().responseJSON{response in
//                switch response.result {
//                    case .success(let value):
//                        let json = JSON(value)
//                        print(json)
//                    case .failure(let error):
//                        print(error)
//            }
//        }
//
        UserDefaults.standard.set(deviceTokenString, forKey: "UserToken")
    }
        
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail to open notification")
        
        //handle failure
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UserDefaults.standard.set(false, forKey: "NotificationSetting")
        print("success to open notification")
        print("\(userInfo)")
        let aps = userInfo["aps"] as! [String: Any]
        print("\(aps)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       UIApplication.shared.applicationIconBadgeNumber = 0
        let email = UserDefaults.standard.string(forKey: "UserEmail") ?? "null"
        let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
        let deviceToken = UserDefaults.standard.string(forKey: "UserToken") ?? "null"
        
        if email != "null" && certificateToken != "null" &&  deviceToken != "null"{
                URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","receivedNotification"], httpMethod: "POST", parameters: ["email":email,"token":certificateToken,"deviceToken":deviceToken]) { (response, success) in
                    if success{
                        print(response)
                    }
                }
        }
    }
//
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"refreshNotificationStatus"), object: nil)
    }
    
}
