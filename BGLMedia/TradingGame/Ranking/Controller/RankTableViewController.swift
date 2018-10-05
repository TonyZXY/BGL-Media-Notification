//
//  RankTableViewController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 3/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RankTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var allRank = [RankObjectViewModel](){
        didSet{
            // sort the data and reload
            allRank.sort(by: ({$0.ranknumber < $1.ranknumber}))
            rankTableView.reloadData()
        }
    }
    
    
    var userRank : RankObjectViewModel?{
        didSet{
            userNickameLabel.text = userRank?.nickname ?? ""
            userStatLabel.text = userRank?.statString ?? ""
            userRankNumberLabel.text = userRank?.ranknumberString ?? ""
        }
    }
    
    lazy var rankTableView : UITableView = {
        var tv = UITableView()
        tv.bounces = false
        tv.backgroundColor = ThemeColor().themeColor()
        tv.separatorStyle = .none
        tv.register(RankTableViewTopCell.self, forCellReuseIdentifier: RankTableViewTopCell.registerID)
        tv.register(RankTableViewBottomCell.self, forCellReuseIdentifier: RankTableViewBottomCell.registerID)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    var userRankView : UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        return view
    }()
    
    var userRankNumberLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "-100."
        return label
    }()
    
    var userNickameLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "Player Default!!!!!"
        return label
    }()
    
    var userStatLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "-10000"
        return label
    }()
    
    let topCellHeight:CGFloat = 150
    let bottomCellHeight:CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.addSubview(rankTableView)
        view.addSubview(userRankView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: rankTableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: userRankView)
        view.addConstraintsWithFormat(format: "V:|[v0]-0-[v1(\(bottomCellHeight))]|", views: rankTableView,userRankView)
        
        userRankView.addSubview(userRankNumberLabel)
        userRankView.addSubview(userNickameLabel)
        userRankView.addSubview(userStatLabel)
        
        let factor = view.frame.width/414
        
        userRankView.addConstraint(NSLayoutConstraint(item: userRankNumberLabel, attribute: .centerY, relatedBy: .equal, toItem: userRankView, attribute: .centerY, multiplier: 1, constant: 0))
        userRankView.addConstraint(NSLayoutConstraint(item: userNickameLabel, attribute: .centerY, relatedBy: .equal, toItem: userRankView, attribute: .centerY, multiplier: 1, constant: 0))
        userRankView.addConstraint(NSLayoutConstraint(item: userStatLabel, attribute: .centerY, relatedBy: .equal, toItem: userRankView, attribute: .centerY, multiplier: 1, constant: 0))
        
        userRankView.addConstraintsWithFormat(format: "H:|-(\(20 * factor))-[v0]-(\(10 * factor))-[v1]", views: userRankNumberLabel,userNickameLabel)
        userRankView.addConstraintsWithFormat(format: "H:[v0]-(\(10 * factor))-|", views: userStatLabel)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let displayNumber = allRank.count - 2
        if  displayNumber <= 1{
            return 1
        }
        return displayNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewTopCell.registerID, for: indexPath) as! RankTableViewTopCell
            // setupview is called after cell initiated to avoid add constraint with default frame (width 320 height 44)
            cell.setupView()
            cell.viewModels = allRank
            return cell
        }else{
            //row > 0
            let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewBottomCell.registerID, for: indexPath) as! RankTableViewBottomCell
            cell.setupView()
            cell.rankViewModel = allRank[indexPath.row+2]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return topCellHeight
        }else{
            return bottomCellHeight
        }
    }
}
