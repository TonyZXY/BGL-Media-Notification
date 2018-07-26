//
//  WalletListsCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 4/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class SelectCoin{
    var selectCoinName:String = ""
    var selectCoinAbbName:String = ""
    var selectExchangeName:String = ""
    var selectTradingPairs:String = ""
}

class WalletsCell:UITableViewCell{
    var color = ThemeColor()
    var selectCoin = SelectCoin()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    func setupView(){
        self.selectionStyle = .none
        addSubview(walletView)
        walletView.addSubview(coinImage)
        walletView.addSubview(coinName)
        walletView.addSubview(profitChange)
        walletView.addSubview(coinAmount)
        walletView.addSubview(coinTotalPrice)
        walletView.addSubview(coinSinglePrice)
        walletView.addSubview(profitChangeNumber)
        
        backgroundColor = ThemeColor().themeColor()
        
        
        //Wallet View
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":walletView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[v0]-3-|", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":walletView]))
        NSLayoutConstraint(item: walletView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: walletView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        
        //CoinImage
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
        NSLayoutConstraint(item: coinImage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: walletView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        //CoinAmount
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-5-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
        NSLayoutConstraint(item: coinAmount, attribute: .centerY, relatedBy: .equal, toItem: coinImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        //CoinName
        NSLayoutConstraint(item: coinName, attribute: .bottom, relatedBy: .equal, toItem: coinAmount, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinName, attribute: .left, relatedBy: .equal, toItem: coinAmount, attribute: .left, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: coinName, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        //CoinTotalPrice
        NSLayoutConstraint(item: coinTotalPrice, attribute: .top, relatedBy: .equal, toItem: coinAmount, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinTotalPrice, attribute: .left, relatedBy: .equal, toItem: coinAmount, attribute: .left, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: coinTotalPrice, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        //ProfitChangeNumber
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v6]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice,"v6":profitChangeNumber]))
        NSLayoutConstraint(item: profitChangeNumber, attribute: .centerY, relatedBy: .equal, toItem: coinImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        //CoinSinglePrice
        NSLayoutConstraint(item: coinSinglePrice, attribute: .bottom, relatedBy: .equal, toItem: profitChangeNumber, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinSinglePrice, attribute: .right, relatedBy: .equal, toItem: profitChangeNumber, attribute: .right, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: coinSinglePrice, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        //ProfitChange
        NSLayoutConstraint(item: profitChange, attribute: .top, relatedBy: .equal, toItem: profitChangeNumber, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profitChange, attribute: .right, relatedBy: .equal, toItem: profitChangeNumber, attribute: .right, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: profitChange, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        
//        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
//        NSLayoutConstraint(item: profitChange, attribute: .centerY, relatedBy: .equal, toItem: coinName, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//
//
//
//
//
//        //CoinSinglePrice
//        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v5]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
//        NSLayoutConstraint(item: coinSinglePrice, attribute: .centerY, relatedBy: .equal, toItem: coinAmount, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//
//        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v4]-5-[v5]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
//
//        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-5-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
    }
    
    let walletView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let coinImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var coinName:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(18)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var profitChange:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.textColor = UIColor.white
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var profitChangeNumber:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.textColor = UIColor.white
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var coinAmount:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var coinTotalPrice:UILabel = {
        var label = UILabel()
        label.text = "(--)"
        label.font = label.font.withSize(13)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var coinSinglePrice:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.font = label.font.withSize(18)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init Error")
    }
}

