
//
//  MainTabBarController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 18/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let network = NetworkManager.sharedInstance
    
    
    let networkLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        label.textColor = .white
        label.text = "Network error. Please check your connection."
        label.font = UIFont(name:"Helvetica-Bold", size:15)
        label.textAlignment = .center
        return label
    }()
    
    @IBOutlet weak var mainTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.reachability.whenUnreachable = { _ in
            print("offline----------------------")
            self.view.addSubview(self.networkLabel)
        }
        
        network.reachability.whenReachable = { _ in
            print("back online -------------------")
            self.networkLabel.removeFromSuperview()
        
        }
        
        
        //debug
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
    }
    
    
    @objc func setUpTab(){
        viewControllers![0].tabBarItem.title = textValue(name: "wallet_tab")
        viewControllers![1].tabBarItem.title = textValue(name: "market_tab")
        viewControllers![2].tabBarItem.title = textValue(name: "flash_tab")
        viewControllers![3].tabBarItem.title = textValue(name: "news_tab")
        viewControllers![4].tabBarItem.title = textValue(name: "more_tab")
        
        let networkLabelFrame = CGRect(x: 0, y: tabBar.frame.minY-80,  width: UIScreen.main.bounds.width, height: 40)
        
        print(tabBar.frame.minY)
        print(UIScreen.main.bounds)
        
        networkLabel.frame = networkLabelFrame
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
