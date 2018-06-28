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
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nihao:String = ""
    
    let coin: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
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
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(coinLabel)
        addSubview(coin)
        addSubview(coinarrow)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coin,"v3":coinarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coin,"v3":coinarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coin,"v3":coinarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3(10)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coin,"v3":coinarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(10)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coin,"v3":coinarrow]))
        let myLabelverticalConstraint = NSLayoutConstraint(item: coinarrow, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([myLabelverticalConstraint])
        //            NSLayoutConstraint.activate([myLabelhorizontalConstraint])
    }

}
