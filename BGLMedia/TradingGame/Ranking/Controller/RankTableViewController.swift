//
//  RankTableViewController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 3/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit


class RankTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    lazy var rankTableView : UITableView = {
        var tv = UITableView()
        tv.bounces = false
        
        tv.register(RankTableViewTopCell.self, forCellReuseIdentifier: RankTableViewTopCell.registerID)
        tv.register(RankTableViewBottomCell.self, forCellReuseIdentifier: RankTableViewBottomCell.registerID)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    var selfRankView : UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var selfRankNumberLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "-100."
        return label
    }()
    
    var selfPlayerNameLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "Player Default!!!!!"
        return label
    }()
    
    var selfPlayerStatLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
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
        view.addSubview(selfRankView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: rankTableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: selfRankView)
        view.addConstraintsWithFormat(format: "V:|[v0]-0-[v1(\(bottomCellHeight))]|", views: rankTableView,selfRankView)
        
        selfRankView.addSubview(selfRankNumberLabel)
        selfRankView.addSubview(selfPlayerNameLabel)
        selfRankView.addSubview(selfPlayerStatLabel)
        
        let factor = view.frame.width/414
        
        selfRankView.addConstraint(NSLayoutConstraint(item: selfRankNumberLabel, attribute: .centerY, relatedBy: .equal, toItem: selfRankView, attribute: .centerY, multiplier: 1, constant: 0))
        selfRankView.addConstraint(NSLayoutConstraint(item: selfPlayerNameLabel, attribute: .centerY, relatedBy: .equal, toItem: selfRankView, attribute: .centerY, multiplier: 1, constant: 0))
        selfRankView.addConstraint(NSLayoutConstraint(item: selfPlayerStatLabel, attribute: .centerY, relatedBy: .equal, toItem: selfRankView, attribute: .centerY, multiplier: 1, constant: 0))
        
        selfRankView.addConstraintsWithFormat(format: "H:|-(\(10 * factor))-[v0(\(10 * factor))]-(\(10 * factor))-[v1(\(250 * factor))]", views: selfRankNumberLabel,selfPlayerNameLabel)
        selfRankView.addConstraintsWithFormat(format: "H:[v0(\(100 * factor))]-(\(10 * factor))-|", views: selfPlayerStatLabel)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewTopCell.registerID, for: indexPath) as! RankTableViewTopCell
            cell.backgroundColor = .yellow
            // setupview is called after cell initiated to avoid add constraint with default frame (width 320 height 44)
            cell.setupView()
            return cell
        }else{
            //row > 0
            let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewBottomCell.registerID, for: indexPath) as! RankTableViewBottomCell
            cell.setupView()
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
