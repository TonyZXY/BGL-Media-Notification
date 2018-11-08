//
//  RankTableCellV2.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 1/11/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankTableViewCell : UITableViewCell{
    public static let registerID = "rankTableViewCell"
    
    var rankViewModel : RankObjectViewModel?{
        didSet{
            self.nicknameLabel.text = rankViewModel?.nickname ?? ""
            self.rankNumberLabel.text = rankViewModel?.ranknumberString ?? ""
            self.statLabel.text = rankViewModel?.statString ?? ""
        }
    }
    
    let baseView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = ThemeColor().walletCellcolor()
        //        view.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        //        view.layer.shadowOpacity = 1
        //        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        return view
    }()
    
    var rankNumberLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.text = ""
        return label
    }()
    
    var nicknameLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.text = ""
        return label
    }()
    
    var statLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.text = ""
        return label
    }()
    
    func setupView(){
        backgroundColor = ThemeColor().themeColor()
        
        let factorNumber = UIScreen.main.bounds.width/414
        
        addSubview(baseView)
        addConstraintsWithFormat(format: "H:|-\(3*factorNumber)-[v0]-\(3*factorNumber)-|", views: baseView)
        addConstraintsWithFormat(format: "V:|-\(2*factorNumber)-[v0]-\(2*factorNumber)-|", views: baseView)
        
        baseView.addSubview(rankNumberLabel)
        baseView.addSubview(nicknameLabel)
        baseView.addSubview(statLabel)
        
        // center alignment for vertical direction
        addConstraint(NSLayoutConstraint(item: rankNumberLabel, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nicknameLabel, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: statLabel, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
        
        let factor = self.frame.width/414
        
        baseView.addConstraintsWithFormat(format: "H:|-(\(20 * factor))-[v0]-(\(10 * factor))-[v1]", views: rankNumberLabel,nicknameLabel)
        baseView.addConstraintsWithFormat(format: "H:[v0]-(\(10 * factor))-|", views: statLabel)
    }
}
