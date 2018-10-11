//
//  RankPopWindowContent.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 11/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankPopWindowContent : UIStackView{
    
    //    var stackView : UIStackView = {
    //        var stack = UIStackView()
    //        return stack
    //    }()
    var weeklyView : UIView = {
        var view = UIView()
        return view
    }()
    
    var totalView : UIView = {
        var view = UIView()
        return view
    }()
    
    // fixed label
    var weeklyLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.text = textValue(name: "rankPopWindow_Weekly")
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    var totalLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.text = textValue(name: "rankPopWindow_Total")
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    // data label
    var weeklyRank : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    var weeklyStat : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    var totalRank : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    var totalStat : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    private func setupContent(rankViewModel : RankObjectViewModel?){
        self.weeklyRank.text = "Rank: \(rankViewModel?.pop_weeklyRank ?? "")"
        self.weeklyStat.text = rankViewModel?.pop_weeklyStat ?? ""
        self.totalRank.text = "Rank: \(rankViewModel?.pop_totalRank ?? "")"
        self.totalStat.text = rankViewModel?.pop_totalStat ?? ""
    }
    
    func setupView(){
        let factor = UIScreen.main.bounds.width/414
        addSubview(weeklyView)
        addSubview(totalView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: weeklyView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: totalView)
        
        weeklyView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        totalView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        weeklyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        totalView.topAnchor.constraint(equalTo: weeklyView.bottomAnchor).isActive = true
        
        weeklyView.addSubview(weeklyLabel)
        weeklyView.addSubview(weeklyRank)
        weeklyView.addSubview(weeklyStat)
        
        weeklyView.addConstraintsWithFormat(format: "H:|-(\(20 * factor))-[v0]", views: weeklyLabel)
        weeklyView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: weeklyRank)
        weeklyView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: weeklyStat)
        addConstraint(NSLayoutConstraint(item: weeklyLabel, attribute: .centerY, relatedBy: .equal, toItem: weeklyView, attribute: .centerY, multiplier: 1, constant: 0))
        weeklyView.addConstraintsWithFormat(format: "V:|-(\(10 * factor))-[v0]-(\(10 * factor))-[v1]", views: weeklyRank,weeklyStat)
        
        totalView.addSubview(totalLabel)
        totalView.addSubview(totalRank)
        totalView.addSubview(totalStat)
        
        totalView.addConstraintsWithFormat(format: "H:|-(\(20 * factor))-[v0]", views: totalLabel)
        totalView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: totalRank)
        totalView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: totalStat)
        addConstraint(NSLayoutConstraint(item: totalLabel, attribute: .centerY, relatedBy: .equal, toItem: totalView, attribute: .centerY, multiplier: 1, constant: 0))
        totalView.addConstraintsWithFormat(format: "V:|-(\(10 * factor))-[v0]-(\(10 * factor))-[v1]", views: totalRank,totalStat)
        
    }
    
    convenience init(rankViewModel : RankObjectViewModel?){
        self.init()
        self.axis = .vertical
        self.spacing = 0
        setupView()
        setupContent(rankViewModel: rankViewModel)
    }
}
