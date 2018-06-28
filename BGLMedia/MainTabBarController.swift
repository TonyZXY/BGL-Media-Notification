
//
//  MainTabBarController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 18/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    @IBOutlet weak var mainTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTab()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setUpTab), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
