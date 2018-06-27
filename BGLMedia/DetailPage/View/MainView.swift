//
//  MainView.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 20/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit

class MainView:UIView{
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
        
        addSubview(portfolio)
        addSubview(portfolioResult)
        addSubview(marketValue)
        addSubview(marketValueRsult)
        addSubview(netCost)
        addSubview(netCostResult)
        
        //portfolio
        NSLayoutConstraint(item: portfolio, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant:0).isActive = true
        NSLayoutConstraint(item: portfolio, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1/3, constant:0).isActive = true
        NSLayoutConstraint(item: portfolio, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -5).isActive = true
        
        //portfolioResult
        NSLayoutConstraint(item: portfolioResult, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: portfolio, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: portfolioResult, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: +5).isActive = true
        
        //marketValue
        NSLayoutConstraint(item: marketValue, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: marketValue, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1/3, constant: 0).isActive = true
         NSLayoutConstraint(item: marketValue, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -5).isActive = true

        //marketValueResult
        NSLayoutConstraint(item: marketValueRsult, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: marketValue, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: marketValueRsult, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: +5).isActive = true
        
        
        //netCost
        NSLayoutConstraint(item: netCost, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant:0).isActive = true
        NSLayoutConstraint(item: netCost, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1/3, constant:0).isActive = true
        NSLayoutConstraint(item: netCost, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -5).isActive = true
        
        //netCostResult
        NSLayoutConstraint(item: netCostResult, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: netCost, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: netCostResult, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: +5).isActive = true
        
    }
    
    var portfolio:UILabel = {
        var label = UILabel()
        label.text = "数量"
        label.font = label.font.withSize(18)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var portfolioResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = label.font.withSize(13)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var marketValue:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(18)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "市值"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var marketValueRsult:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(13)
        label.text = "0"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var netCost:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(18)
        label.text = "净值"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var netCostResult:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(13)
        label.text = "0"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

