//
//  RankMenuController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 27/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankViewController : UIViewController{
    let factor = UIScreen.main.bounds.width/375
    
    lazy var menuBar : MenuPageView = {
        let page1 = MenuPage(title: textValue(name: "rankMenuTitle_Weekly"),pageView: weeklyContainer)
        let page2 = MenuPage(title: textValue(name: "rankMenuTitle_Total"),pageView: totalContainer)
        let menu = MenuPageView(menuPages: [page1,page2])
        
        menu.menuBarBackgroundColor = ThemeColor().themeColor()
        menu.selectedMenuColor = ThemeColor().themeWidgetColor()
        menu.notSelectedMenuColor = ThemeColor().textGreycolor()
        menu.horizontalMenuBarColor = ThemeColor().themeWidgetColor()
        return menu
    }()
    
    var weeklyRankTableController = WeeklyRankTableViewController()
    var totalRankTableController = TotalRankTableViewController()
    
    
    lazy var weeklyContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(childViewController: self.weeklyRankTableController, view: view)
        return view
    }()
    
    lazy var totalContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(childViewController: self.totalRankTableController, view: view)
        return view
    }()
    
    
    private func setupView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        
        view.addSubview(menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeArea().topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.safeArea().leadingAnchor).isActive = true
        menuBar.bottomAnchor.constraint(equalTo: view.safeArea().bottomAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.safeArea().trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}
