//
//  AllLossView.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 20/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit

class AllLossView:UIView{
    var factor:CGFloat?{
        didSet{
            setUpView()
        }
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setUpView(){
        backgroundColor = ThemeColor().darkBlackColor()
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(allTimeLoss)
        addSubview(profitLoss)
        allTimeLoss.text = textValue(name: "allTimeProfit_detail_detail")
        
        
        //AllTimeLoss
        NSLayoutConstraint(item: allTimeLoss, attribute: .right, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant:-5).isActive = true
        NSLayoutConstraint(item: allTimeLoss, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant:0).isActive = true
        
        //ProfitLoss
        NSLayoutConstraint(item: profitLoss, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: +5).isActive = true
        NSLayoutConstraint(item: profitLoss, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant:0).isActive = true
        
        profitLoss.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    lazy var allTimeLoss:UILabel = {
        var label = UILabel()
        //        label.text = "总收益:"
        label.textColor = UIColor.white
        label.font = UIFont.regularFont(16*factor!)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profitLoss:UILabel = {
        var label = UILabel()
        label.font = UIFont.regularFont(16*factor!)
        label.text = "0"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}


