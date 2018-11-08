//
//  AssetController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 24/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class AssetController: UIViewController {
    let factor = UIScreen.main.bounds.width/375
    
    lazy var menuPageView : MenuPageView = {
        var menu = MenuPageView()
        let page1 = MenuPage(title: textValue(name: "asset_menu_wallet"), pageView: walletContainer)
        let page2 = MenuPage(title: textValue(name: "asset_menu_game"), pageView: gameBalanceContainer)
        menu.currentIndexDidChange = { index in
            if index == 1 {
                self.gameBalanceController.checkLoginStatus()
            }
        }
        menu.menuPages = [page1,page2]
        menu.horizontalMenuBarColor = ThemeColor().themeWidgetColor()
        menu.menuBarHeight = 50 * factor
        menu.selectedMenuColor = ThemeColor().themeWidgetColor()
        menu.notSelectedMenuColor = ThemeColor().textGreycolor()
        menu.menuBarBackgroundColor = ThemeColor().themeColor()
        menu.setPagesBounce(false)
        return menu
    }()
    
    lazy var walletContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(childViewController: self.walletController, view: view)
        return view
    }()
    
    lazy var gameBalanceContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(childViewController: self.gameBalanceController, view: view)
        return view
    }()
    
    let gameBalanceController = GameBalanceController()
    let walletController = WalletController()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.semiBoldFont(17*factor)
        titleLabel.text = textValue(name: "asset_title")
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    @objc func changeLanguage(){
        if let walletLabel = self.menuPageView.menuPages[0].menuView as? UILabel{
            walletLabel.text = textValue(name: "asset_menu_wallet")
        }
        if let gameLabel = self.menuPageView.menuPages[1].menuView as? UILabel{
            gameLabel.text = textValue(name: "asset_menu_game")
        }
    }
    
    func setupView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        navigationItem.titleView = titleLabel
        
        view.addSubview(menuPageView)
        menuPageView.topAnchor.constraint(equalTo: view.safeArea().topAnchor).isActive = true
        menuPageView.leadingAnchor.constraint(equalTo: view.safeArea().leadingAnchor).isActive = true
        menuPageView.bottomAnchor.constraint(equalTo: view.safeArea().bottomAnchor).isActive = true
        menuPageView.trailingAnchor.constraint(equalTo: view.safeArea().trailingAnchor).isActive = true
    }
}


