//
//  CoinTypeTableViewCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 1/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class CoinTypeTableViewCell:UITableViewCell{
    var coinNameItem = ["Bitcoin","CyberMiles"]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    let coinImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let coinName:UILabel={
       var coinName = UILabel()
        coinName.translatesAutoresizingMaskIntoConstraints = false
       return coinName
    }()
    
    let coinNameAbb:UILabel={
        var coinNameAbb = UILabel()
        coinNameAbb.translatesAutoresizingMaskIntoConstraints = false
        return coinNameAbb
    }()
    
    func setupView(){
        addSubview(coinImage)
        addSubview(coinName)
        addSubview(coinNameAbb)
//        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1)
//        layer.shadowOpacity = 0.5
//        layer.shadowRadius = 1
//        layer.masksToBounds = false
        
        NSLayoutConstraint(item: coinImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinName, attribute: .bottom, relatedBy: .equal, toItem: coinImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
         NSLayoutConstraint(item: coinNameAbb, attribute: .top, relatedBy: .equal, toItem: coinImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
         NSLayoutConstraint(item: coinName, attribute: .left, relatedBy: .equal, toItem: coinNameAbb, attribute: .left, multiplier: 1, constant: 0).isActive = true

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(30)]-5-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":coinNameAbb]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":coinNameAbb]))


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
}
