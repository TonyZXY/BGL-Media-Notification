//
//  TransTradePrice.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

@IBDesignable
class TransTradePairsCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let tradeLabel:UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(18)
        return label
    }()
    
    let trade: InsetLabel = {
        let label = InsetLabel()
        label.textColor = ThemeColor().whiteColor()
        label.layer.cornerRadius = 8
        label.font = label.font.withSize(15)
        label.layer.backgroundColor = ThemeColor().greyColor().cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(tradeLabel)
        addSubview(trade)
        accessoryType = .disclosureIndicator
        
        
        NSLayoutConstraint(item: tradeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trade, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade]))
    }
}
