
//
//  MainTabBarController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 18/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MainTabBarController: UITabBarController,UITabBarControllerDelegate {
    
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
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if tabBarController.selectedIndex == 2{
//            viewControllers![2].tabBarItem.badgeValue = nil
//            UIApplication.shared.applicationIconBadgeNumber = 0
//            if loginStatus{
//                if getDeviceToken{
//                    if self.email != "null" && self.certificateToken != "null" &&  self.deviceToken != "null"{
//                        URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","receivedNotification"], httpMethod: "POST", parameters: ["email":email,"token":certificateToken,"deviceToken":deviceToken]) { (response, success) in
//                            if success{
//                                print(response)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    let network = NetworkManager.sharedInstance
    let forceUpdateAlert = ForceUpdateAlertController()
    let updateAlert = UpdateAlertViewController()
    
    let networkLabel:UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        label.backgroundColor = ThemeColor().redColorTran()
        label.textColor = .white
        label.text = "Network error. Please check your connection."
        label.font = UIFont(name:"Helvetica-Bold", size:15)
        label.textAlignment = .center
        return label
    }()
    
    @IBOutlet weak var mainTabBar: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let versionNumber: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //            let buildVersion: Any = Bundle.main.infoDictionary!["CFBundleVersion"] ?? ""
        
        
        APIServices.fetchInstance.getLatestVersion(){response,success in
            if success{
                print(response["results"][0]["version"])
                if let version = response["results"][0]["version"].string{
                    let newVersionMin : [String] = version.components(separatedBy: ".")
                    let oldVersionMin:[String] = versionNumber.components(separatedBy: ".")
                    print(newVersionMin)
                    print(oldVersionMin)
                    if newVersionMin.count == oldVersionMin.count{
                        for i in 0...newVersionMin.count-1{
                            if i == 0{
                                if newVersionMin[i] != oldVersionMin[i] {
                                    print("set")
                                    self.forceUpdateAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                                    self.forceUpdateAlert.updateButton.addTarget(self, action: #selector(self.forceUpdate), for: .touchUpInside)
                                    self.forceUpdateAlert.titleLabel.text = textValue(name: "updateTitle_tab")
                                    self.forceUpdateAlert.descriptionLabel.text = textValue(name: "updateDescription_tab")
                                    self.forceUpdateAlert.updateButton.setTitle(textValue(name: "updateAlert_tab"), for: .normal)
                                    self.addChildViewController(self.forceUpdateAlert)
                                    self.view.addSubview(self.forceUpdateAlert.view)
                                }
                            }else if i == 1{
                                if newVersionMin[i] != oldVersionMin[i]{
                                    print("setss")
                                    self.updateAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                                    self.updateAlert.updateButton.addTarget(self, action: #selector(self.forceUpdate), for: .touchUpInside)
                                    self.updateAlert.titleLabel.text = textValue(name: "updateTitle_tab")
                                    self.updateAlert.descriptionLabel.text = textValue(name: "updateDescription_tab")
                                    self.updateAlert.cancelButton.setTitle(textValue(name: "cancelAlert_tab"), for: .normal)
                                    self.updateAlert.updateButton.setTitle(textValue(name: "updateAlert_tab"), for: .normal)
                                    self.updateAlert.cancelButton.addTarget(self, action: #selector(self.cancelAlert), for: .touchUpInside)
                                    self.addChildViewController(self.updateAlert)
                                    self.view.addSubview(self.updateAlert.view)
                                }
                            } else if i == 2{
                                if newVersionMin[i] != oldVersionMin[i]{
                                    self.updateAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                                    self.updateAlert.updateButton.addTarget(self, action: #selector(self.forceUpdate), for: .touchUpInside)
                                    self.updateAlert.titleLabel.text = textValue(name: "updateTitle_tab")
                                    self.updateAlert.descriptionLabel.text = textValue(name: "updateDescription_tab")
                                    self.updateAlert.cancelButton.setTitle(textValue(name: "cancelAlert_tab"), for: .normal)
                                    self.updateAlert.updateButton.setTitle(textValue(name: "updateAlert_tab"), for: .normal)
                                    self.updateAlert.cancelButton.addTarget(self, action: #selector(self.cancelAlert), for: .touchUpInside)
                                    self.addChildViewController(self.updateAlert)
                                    self.view.addSubview(self.updateAlert.view)
                                }
                            }
                        }
                    }
                }
            }
        }
    
                
                        
                        
                        

            
            
            
            
//            if success{
//                if let version = response["version"].string{
//                    if version != "\(versionNumber)(\(buildVersion))"{
//                        if let critical = response["critical"].bool{
//                            if critical{
//                                self.forceUpdateAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//                                self.forceUpdateAlert.updateButton.addTarget(self, action: #selector(self.forceUpdate), for: .touchUpInside)
//                                self.forceUpdateAlert.titleLabel.text = textValue(name: "updateTitle_tab")
//                                self.forceUpdateAlert.descriptionLabel.text = textValue(name: "updateDescription_tab")
//                                self.forceUpdateAlert.updateButton.setTitle(textValue(name: "updateAlert_tab"), for: .normal)
//                                self.addChildViewController(self.forceUpdateAlert)
//                                self.view.addSubview(self.forceUpdateAlert.view)
//                            } else{
//                                self.updateAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//                                self.updateAlert.updateButton.addTarget(self, action: #selector(self.forceUpdate), for: .touchUpInside)
//                                self.updateAlert.titleLabel.text = textValue(name: "updateTitle_tab")
//                                self.updateAlert.descriptionLabel.text = textValue(name: "updateDescription_tab")
//                                self.updateAlert.cancelButton.setTitle(textValue(name: "cancelAlert_tab"), for: .normal)
//                                self.updateAlert.updateButton.setTitle(textValue(name: "updateAlert_tab"), for: .normal)
//                                self.updateAlert.cancelButton.addTarget(self, action: #selector(self.cancelAlert), for: .touchUpInside)
//                                self.addChildViewController(self.updateAlert)
//                                self.view.addSubview(self.updateAlert.view)
//                            }
//                        }
//                    }
//                }
//            } else{}
//        }
    
        
        
        
        
        
        
        
        
        
        
        
        
//        self.navigationController.bar
        let backItem = UIBarButtonItem()
        backItem.title = textValue(name: "back_button")
        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
        /*Changing color*/
        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
//        self.navigationController?.navigationBar.backItem?.backBarButtonItem = backItem
        self.navigationItem.backBarButtonItem = backItem
         
        network.reachability.whenUnreachable = { _ in
            print("offline----------------------")
            self.view.addSubview(self.networkLabel)
        }
        
        network.reachability.whenReachable = { _ in
            print("back online -------------------")
            self.networkLabel.removeFromSuperview()
        
        }
        
        
//        debug
//        NetworkManager.isReachable{ _ in
//            self.view.addSubview(self.networkLabel)
//        }
        
        NetworkManager.isUnreachable{ _ in
            self.view.addSubview(self.networkLabel)
        }
        
        
        //        NetworkManager.isReachable { _ in
        //            print("online===============set up tabs")
        self.setUpTab()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setUpTab), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInternalBadge), name: NSNotification.Name(rawValue: "refreshInternalBadge"), object: nil)
        
        
        
        
        //        }
        
        
        //
        //        let walletController = UINavigationController(rootViewController: WalletController())
        //        walletController.tabBarItem.image = UIImage(named: "icons8-mywallet-25")
        //        walletController.tabBarItem.title = "sds"
        //
        //        let marketController = UINavigationController(rootViewController: MarketController())
        //        marketController.tabBarItem.image = UIImage(named: "icons8-market-25")
        //
        //        let flashNewsController = UINavigationController(rootViewController: NewsFlashViewController())
        //        flashNewsController.tabBarItem.image = UIImage(named: "icons8-newsflash-25")
        //
        //        let newsController = UINavigationController(rootViewController: NewsHomeViewController())
        //        newsController.tabBarItem.image = UIImage(named: "icons8-news-25")
        //
        //        let settingController = UINavigationController(rootViewController: MoreOptionMainViewController())
        //        settingController.tabBarItem.image = UIImage(named: "icons8-otheroptions-25")
        
        //        viewControllers = [walletController,marketController,flashNewsController,newsController,settingController]
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshInternalNotification"), object: nil)
    }
    
    @objc func updateInternalBadge(){
        if UIApplication.shared.applicationIconBadgeNumber > 0{
            viewControllers![2].tabBarItem.badgeValue = "\(UIApplication.shared.applicationIconBadgeNumber)"
        }else{
            viewControllers![2].tabBarItem.badgeValue = nil
        }
    }
    
    @objc func forceUpdate(){
        let appID = "1406241883"
        let urlStr2 = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software" // (Option 2) Open App Review Tab
        
        if let url = URL(string: urlStr2), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func cancelAlert(){
        updateAlert.removeFromParentViewController()
        updateAlert.view.removeFromSuperview()
    }
    
    @objc func setUpTab(){
        viewControllers![0].tabBarItem.title = textValue(name: "wallet_tab")
//        viewControllers![0].tabBarItem.setsel
        viewControllers![0].tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(10)], for: .normal)
        viewControllers![1].tabBarItem.title = textValue(name: "market_tab")
        viewControllers![1].tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(10)], for: .normal)
        viewControllers![2].tabBarItem.title = textValue(name: "news_tab")
        updateInternalBadge()
        viewControllers![2].tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(10)], for: .normal)
        viewControllers![3].tabBarItem.title = textValue(name: "event_tab")
        viewControllers![3].tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(10)], for: .normal)
        viewControllers![4].tabBarItem.title = textValue(name: "more_tab")
        viewControllers![4].tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(10)], for: .normal)
        let networkLabelFrame = CGRect(x: 0, y: tabBar.frame.minY-80,  width: UIScreen.main.bounds.width, height: 40)
        
//        print(tabBar.frame.minY)
//        print(UIScreen.main.bounds)
        
        // put the badge number on to the flash_tab
        networkLabel.frame = networkLabelFrame
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            // ask server ti clear badge number
            viewController.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
            //        let email = UserDefaults.standard.string(forKey: "UserEmail") ?? "null"
            //        let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
            //        let deviceToken = UserDefaults.standard.string(forKey: "UserToken") ?? "null"
            
            if loginStatus{
                if getDeviceToken{
                    if self.email != "null" && self.certificateToken != "null" &&  self.deviceToken != "null"{
                        URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","receivedNotification"], httpMethod: "POST", parameters: ["email":email,"token":certificateToken,"deviceToken":deviceToken]) { (response, success) in
                            if success{
                                //                            print(response)
                            }
                        }
                    }
                }
            }
            else{
                if getDeviceToken{
                    // send  recievedNotification query
                    if self.deviceToken != "null"{
                        print(deviceToken)
                        URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","receivedIOSNotification"], httpMethod: "POST", parameters: ["deviceToken": deviceToken]){(response,success) in
                            if success{
                                print(response)
                            }
                        }
                    }
                }
            }
        }
    }
}
