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
    var factor:CGFloat?{
        didSet{
            setupview()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    lazy var marketLabel:UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
       label.font = UIFont.semiBoldFont(15*factor!)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var market: InsetLabel = {
        let label = InsetLabel()
        label.layer.cornerRadius = 8*factor!
        label.layer.backgroundColor = ThemeColor().greyColor().cgColor
        label.font = UIFont.semiBoldFont(13*factor!)
        label.textColor = ThemeColor().whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupview(){
//        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowOpacity = 1
//        layer.shadowRadius = 0
//        layer.masksToBounds = false
        
        backgroundColor = ThemeColor().themeColor()
        addSubview(marketLabel)
        addSubview(market)
        accessoryType = .disclosureIndicator
        
        
        NSLayoutConstraint(item: marketLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: market, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v0]-\(10*factor!)-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market]))
        market.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -40*factor!).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market]))
    
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3(10)]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(10)]", options: .alignAllCenterX, metrics: nil, views: ["v0":marketLabel,"v1":market,"v3":marketarrow]))
//        let myLabelverticalConstraint = NSLayoutConstraint(item: marketarrow, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
//        NSLayoutConstraint.activate([myLabelverticalConstraint])
    }
}

//class TradePairs:UITableViewCell{
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupviews()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init has not been completed")
//    }
//    
//    let tradeLabel:UILabel = {
//        let label = UILabel()
//        label.text = "兑换币种"
//        label.textColor = ThemeColor().textGreycolor()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let trade: UILabel = {
//        let label = UILabel()
//        label.text = "BTC/AUD"
//        label.textColor = ThemeColor().whiteColor()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let tradearrow: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
//        imageView.clipsToBounds = true
//        imageView.contentMode = UIViewContentMode.scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    func setupviews(){
////        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
////        layer.shadowOffset = CGSize(width: 0, height: 3)
////        layer.shadowOpacity = 1
////        layer.shadowRadius = 0
////        layer.masksToBounds = false
//        
//        addSubview(tradeLabel)
//        addSubview(trade)
//        addSubview(tradearrow)
//        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(16*factor!)-[v0]-\(10*factor!)-[v1]-\(16*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3(\(10*factor!)]-\(16*factor!)-|", options: .alignAllCenterY, metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(\(10*factor!)]", options: .alignAllCenterX, metrics: nil, views: ["v0":tradeLabel,"v1":trade,"v3":tradearrow]))
//        let myLabelverticalConstraint = NSLayoutConstraint(item: tradearrow, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
//        NSLayoutConstraint.activate([myLabelverticalConstraint])
//    }
//}

