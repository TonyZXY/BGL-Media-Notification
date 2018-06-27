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
    override init (frame : CGRect) {
        super.init(frame : frame)
        setUpView()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setUpView(){
        backgroundColor = ThemeColor().themeColor()
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(allTimeLoss)
        addSubview(profitLoss)
        
        //AllTimeLoss
        NSLayoutConstraint(item: allTimeLoss, attribute: .right, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant:-5).isActive = true
        NSLayoutConstraint(item: allTimeLoss, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant:0).isActive = true
        
        //ProfitLoss
        NSLayoutConstraint(item: profitLoss, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: +5).isActive = true
        NSLayoutConstraint(item: profitLoss, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .centerY, multiplier: 1, constant:0).isActive = true
    }
    
    var allTimeLoss:UILabel = {
        var label = UILabel()
        label.text = "总收益:"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var profitLoss:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}


