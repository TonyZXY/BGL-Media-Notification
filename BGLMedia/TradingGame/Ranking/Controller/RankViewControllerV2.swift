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
        let page1 = MenuPage(title: textValue(name: "rankMenuTitle_Total"),pageView: totalContainer)
        let page2 = MenuPage(title: textValue(name: "rankMenuTitle_Competition"),pageView: competitionContainer)
        let menu = MenuPageView(menuPages: [page1,page2])
        
        menu.menuBarBackgroundColor = ThemeColor().themeColor()
        menu.horizontalMenuBarColor = ThemeColor().themeWidgetColor()
        menu.selectedMenuColor = ThemeColor().themeWidgetColor()
        menu.notSelectedMenuColor = ThemeColor().textGreycolor()
//        menu.horizontalBarHeight = 0
        menu.setPagesBounce(false)
        return menu
    }()
    
    var competitionRankTableController = CompetitionTableViewControllerV2()
    var totalRankTableController = TotalRankTableViewControllerV2()
    
    
//    var totalMenuCell = RankMenuCell(menuTitle: textValue(name: "rankMenuTitle_Total"))
//    var competitionMenuCell = RankMenuCell(menuTitle : textValue(name: "rankMenuTitle_Competition"))
    
    lazy var competitionContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(childViewController: self.competitionRankTableController, view: view)
        return view
    }()
    
    lazy var totalContainer:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(childViewController: self.totalRankTableController, view: view)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = textValue(name: "rankNavTitle")
        titleLabel.font = UIFont.semiBoldFont(17*factor)
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private func setupView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        self.navigationItem.titleView = titleLabel
        
        view.addSubview(menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeArea().topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.safeArea().leadingAnchor).isActive = true
        menuBar.bottomAnchor.constraint(equalTo: view.safeArea().bottomAnchor).isActive = true
        menuBar.trailingAnchor.constraint(equalTo: view.safeArea().trailingAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    @objc func changeLanguage(){
        titleLabel.text = textValue(name: "rankNavTitle")
        
        if let totalLabel = self.menuBar.menuPages[0].menuView as? UILabel{
            totalLabel.text = textValue(name: "rankMenuTitle_Total")
        }
        if let competitionLabel = self.menuBar.menuPages[1].menuView as? UILabel{
            competitionLabel.text = textValue(name: "rankMenuTitle_Competition")
        }
    }
}

//class RankMenuCell : UIView,CustomMenuCell{
//
//    func selected() {
//        containerView.backgroundColor = ThemeColor().themeColor() * 1.5
//        containerView.layer.borderColor = ThemeColor().themeWidgetColor().cgColor
//        menuLabel.textColor = ThemeColor().whiteColor()
//    }
//
//    func notselected() {
//        containerView.backgroundColor = ThemeColor().themeColor()
//        containerView.layer.borderColor = UIColor.clear.cgColor
//        menuLabel.textColor = ThemeColor().textGreycolor()
//    }
//
//    let factor = UIScreen.main.bounds.width/375
//
//    lazy var containerView : UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5 * factor
//        view.layer.borderWidth = 4 * factor
//        return view
//    }()
//
//    lazy var menuLabel : UILabel = {
//        let menuLabel = UILabel()
//        menuLabel.font = UIFont.regularFont(18*factor)
//        menuLabel.textColor = ThemeColor().whiteColor()
//        menuLabel.textAlignment = .center
//        return menuLabel
//    }()
//
//    private func setupView(){
//        addSubview(containerView)
//        self.addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]-\(10*factor)-|", views: containerView)
//        self.addConstraintsWithFormat(format: "V:|-\(3*factor)-[v0]-\(3*factor)-|", views: containerView)
//        containerView.addSubview(menuLabel)
//        self.addConstraintsWithFormat(format: "H:|-\(2*factor)-[v0]-\(2*factor)-|", views: menuLabel)
//        self.addConstraintsWithFormat(format: "V:|-\(2*factor)-[v0]-\(2*factor)-|", views: menuLabel)
//    }
//
//    convenience init(menuTitle: String){
//        self.init()
//        setupView()
//        self.menuLabel.text = menuTitle
//
//    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
