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
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(30)]-5-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":coinNameAbb]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[v0(30)]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":coinNameAbb]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-5-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":coinNameAbb]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v1]-5-[v2]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":coinNameAbb]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
}
