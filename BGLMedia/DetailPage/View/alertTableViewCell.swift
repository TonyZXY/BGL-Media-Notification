//
//  alertTableViewCell.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 26/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import Foundation
import UIKit

class AlertTableViewCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func setUpView(){
        addSubview(swithButton)
        addSubview(compareLabel)
        addSubview(dateLabel)
        addSubview(coinDetailLabel)
        
        NSLayoutConstraint(item: swithButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: swithButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: compareLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: compareLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-5-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":compareLabel]))
        NSLayoutConstraint(item: coinDetailLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailLabel,"v1":compareLabel]))
        
    }
    
    var swithButton:UISwitch = {
        var switchButton = UISwitch()
        switchButton.isOn = false
//        switchButton.thumbTintColor = UIColor.red
//        switchButton.tintColor = UIColor.green
//        switchButton.onTintColor = ThemeColor().bglColor()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    var compareLabel:UILabel = {
       var label = UILabel()
        label.text = "haha"
        label.font = label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel:UILabel = {
        var label = UILabel()
        label.text = "haha"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var coinDetailLabel:UILabel = {
        var label = UILabel()
        label.text = "haha"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
}
