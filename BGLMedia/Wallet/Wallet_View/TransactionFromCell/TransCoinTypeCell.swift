//
//  TransCoinType.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
@IBDesignable
class TransCoinTypeCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let coinLabel:UILabel = {
        let label = UILabel()
        label.text = "币种"
//        label.font = UIFont(name: "Montserrat-Italic", size: 18)
        label.font = UIFont.semiBoldFont(18)
        label.textAlignment = .left
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coin:InsetLabel = {
        let label = InsetLabel()
        label.textColor = UIColor.white
        label.layer.cornerRadius = 8
        label.layer.backgroundColor = ThemeColor().greyColor().cgColor
        label.font = UIFont.regularFont(15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coinarrow: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupviews(){
        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
        layer.masksToBounds = false

        backgroundColor = ThemeColor().themeColor()
        addSubview(coinLabel)
        addSubview(coin)
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint(item: coinLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coin, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coin,"v3":coinarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coin,"v3":coinarrow]))
    }

    
    
}

