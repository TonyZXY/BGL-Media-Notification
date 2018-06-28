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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        application.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = ThemeColor().themeColor()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ (granted, error) in
            print("granted:\(granted)") }// user reaction handling
        UIApplication.shared.registerForRemoteNotifications()
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore{
            print("launched")
        } else{
            UserDefaults.standard.set("AUD", forKey: "defaultCurrency")
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
        
        let deviceTokenString = deviceToken.reduce("",{$0 + String(format: "%02X",$1)})
        print("token:\(deviceTokenString)")
        let deviceTokenJson: [String: Any] = [
            "deviceID": deviceTokenString,
            "notification": true
        ]
        Alamofire.request("http://10.10.6.139:3030/deviceManage/addIOSDevice", method: .post, parameters: deviceTokenJson, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).validate().responseJSON{response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                    case .failure(let error):
                        print(error)
            }
        }
        
    }
        
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //handle failure
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("\(userInfo)")
        let aps = userInfo["aps"] as! [String: Any]
        print("\(aps)")
    }
    
}
