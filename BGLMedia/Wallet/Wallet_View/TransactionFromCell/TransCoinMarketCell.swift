//
//  TransCoinMarket.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

@IBDesignable
class TransCoinMarketCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupview()
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let marketLabel:UILabel = {
        let label = UILabel()
        label.text = "交易市场"
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let market: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let marketarrow: UIImageView = {
        //            let imageView  = UIImageView();
        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        //            imageView.frame = CGRect(x:0, y: 0, width: 30, height: 30)
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        //            imageView.image = UIImage(named:"bcg_logo.png")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupview(){
        backgroundColor = ThemeColor().themeColor()
        addSubview(marketLabel)
        addSubview(market)
        addSubview(marketarrow)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3(10)]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(10)]", options: .alignAllCenterX, metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
        let myLabelverticalConstraint = NSLayoutConstraint(item: marketarrow, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([myLabelverticalConstraint])
    }
}

class TradePairs:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let tradeLabel:UILabel = {
        let label = UILabel()
        label.text = "兑换币种"
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trade: UILabel = {
        let label = UILabel()
        label.text = "BTC/AUD"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tradearrow: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupviews(){
        addSubview(tradeLabel)
        addSubview(trade)
        addSubview(tradearrow)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3(10)]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(10)]", options: .alignAllCenterX, metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
        let myLabelverticalConstraint = NSLayoutConstraint(item: tradearrow, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([myLabelverticalConstraint])
    }
}

