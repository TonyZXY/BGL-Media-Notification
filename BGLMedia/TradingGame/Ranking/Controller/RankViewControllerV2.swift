//
//  RankViewControllerV2.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 1/11/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankViewControllerV2: UIViewController {
    let factor = UIScreen.main.bounds.width/375
    
    lazy var menuBar : MenuPageView = {
        let page1 = MenuPage(title: textValue(name: "rankMenuTitle_Weekly"),menuView: self.seasonMenuCell,pageView: weeklyContainer)
        let page2 = MenuPage(title: textValue(name: "rankMenuTitle_Total"),menuView: self.totalMenuCell,pageView: totalContainer)
        let menu = MenuPageView(menuPages: [page1,page2])
        
        menu.menuBarBackgroundColor = ThemeColor().themeColor()
//        menu.selectedMenuColor = ThemeColor().themeWidgetColor()
//        menu.notSelectedMenuColor = ThemeColor().textGreycolor()
        menu.menuBarPadding = 0
        menu.horizontalBarHeight = 0
        
        return menu
    }()
    
    var totalMenuCell = RankMenuCell()
    var seasonMenuCell = RankMenuCell()
    
    lazy var weeklyContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().grayLightColor()
//        addChildViewController(childViewController: self.weeklyRankTableController, view: view)
        return view
    }()
    
    lazy var totalContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().grayLightColor()
//        addChildViewController(childViewController: self.totalRankTableController, view: view)
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

class RankMenuCell : UIView,CustomMenuCell{
    
    func selected() {
        containerView.backgroundColor = ThemeColor().grayLightColor()
        containerView.layer.borderColor = ThemeColor().themeWidgetColor().cgColor
    }
    
    func notselected() {
        containerView.backgroundColor = ThemeColor().progressColor()
        containerView.layer.borderColor = UIColor.clear.cgColor
    }
    
    let factor = UIScreen.main.bounds.width/375
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5 * factor
        view.layer.borderWidth = 4 * factor
        return view
    }()
    
    private func setupView(){
        addSubview(containerView)
        self.addConstraintsWithFormat(format: "H:|-\(5*factor)-[v0]-\(5*factor)-|", views: containerView)
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5*factor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5*factor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
