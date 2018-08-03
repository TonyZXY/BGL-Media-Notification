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
    var factor:CGFloat?{
        didSet{
            setupviews()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    lazy var tradeLabel:UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
       label.font = UIFont.semiBoldFont(18*factor!)
        return label
    }()
    
    lazy var trade: InsetLabel = {
        let label = InsetLabel()
        label.textColor = ThemeColor().whiteColor()
        label.layer.cornerRadius = 8*factor!
        label.font = UIFont.regularFont(15*factor!)
        label.layer.backgroundColor = ThemeColor().greyColor().cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupviews(){
//        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowOpacity = 1
//        layer.shadowRadius = 0
//        layer.masksToBounds = false
        
        
        backgroundColor = ThemeColor().themeColor()
        addSubview(tradeLabel)
        addSubview(trade)
        accessoryType = .disclosureIndicator
        
        
        NSLayoutConstraint(item: tradeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: trade, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v0]-\(10*factor!)-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade]))
    }
}
