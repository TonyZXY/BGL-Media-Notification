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
    var factor:CGFloat?{
        didSet{
            setupView()
        }
    }
    var color = ThemeColor()
    var selectCoin = SelectCoin()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        walletView.addSubview(unrealisedLabel)
        walletView.addSubview(unrealisedPrice)
        
        
        backgroundColor = ThemeColor().themeColor()
        
        
        //Wallet View
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor!)-[v0]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":walletView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(10*factor!)-[v0]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":walletView]))
        
//        walletView.bottomAnchor.constra
        
        
//        NSLayoutConstraint(item: walletView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: walletView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        
        //CoinImage
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(5*factor!)-[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views:
            ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
//        NSLayoutConstraint(item: coinImage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: walletView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        
        
        
        //CoinAmount
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(5*factor!)-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice]))
        NSLayoutConstraint(item: coinAmount, attribute: .centerY, relatedBy: .equal, toItem: coinImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        //CoinName
        NSLayoutConstraint(item: coinName, attribute: .bottom, relatedBy: .equal, toItem: coinAmount, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinName, attribute: .left, relatedBy: .equal, toItem: coinAmount, attribute: .left, multiplier: 1, constant: 0).isActive = true
        
        //CoinTotalPrice
        NSLayoutConstraint(item: coinTotalPrice, attribute: .top, relatedBy: .equal, toItem: coinAmount, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinTotalPrice, attribute: .left, relatedBy: .equal, toItem: coinAmount, attribute: .left, multiplier: 1, constant: 0).isActive = true
        
        //ProfitChangeNumber
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v6]-\(5*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinName,"v2":profitChange,"v3":coinAmount,"v4":coinTotalPrice,"v5":coinSinglePrice,"v6":profitChangeNumber]))
        NSLayoutConstraint(item: profitChangeNumber, attribute: .centerY, relatedBy: .equal, toItem: coinImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        //CoinSinglePrice
        NSLayoutConstraint(item: coinSinglePrice, attribute: .bottom, relatedBy: .equal, toItem: profitChangeNumber, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinSinglePrice, attribute: .right, relatedBy: .equal, toItem: profitChangeNumber, attribute: .right, multiplier: 1, constant: 0).isActive = true
        
        //ProfitChange
        NSLayoutConstraint(item: profitChange, attribute: .top, relatedBy: .equal, toItem: profitChangeNumber, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: profitChange, attribute: .right, relatedBy: .equal, toItem: profitChangeNumber, attribute: .right, multiplier: 1, constant: 0).isActive = true
        //        NSLayoutConstraint(item: profitChange, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        coinName.rightAnchor.constraint(lessThanOrEqualTo: coinSinglePrice.leftAnchor, constant: -10).isActive = true
        coinAmount.rightAnchor.constraint(lessThanOrEqualTo: profitChangeNumber.leftAnchor, constant: -10).isActive = true
        coinTotalPrice.rightAnchor.constraint(lessThanOrEqualTo: profitChange.leftAnchor, constant: -10).isActive = true
        
        coinName.topAnchor.constraint(equalTo: walletView.topAnchor, constant: 10).isActive = true
        unrealisedLabel.topAnchor.constraint(equalTo: coinTotalPrice.bottomAnchor, constant: 0).isActive = true
        unrealisedLabel.leftAnchor.constraint(equalTo: coinTotalPrice.leftAnchor, constant: 0).isActive = true
        unrealisedPrice.rightAnchor.constraint(equalTo: profitChange.rightAnchor, constant: 0).isActive = true
        unrealisedPrice.topAnchor.constraint(equalTo: profitChange.bottomAnchor, constant: 0).isActive = true
        unrealisedPrice.bottomAnchor.constraint(equalTo: walletView.bottomAnchor, constant: -10).isActive = true
    }
    
    lazy var unrealisedLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().unrealisedPriceColor()
        label.numberOfLines = 0
        label.font = label.font.withSize(12*factor!)
        label.textAlignment = .center
//        label.text = "unrealized price"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    lazy var unrealisedPrice:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().unrealisedPriceColor()
        label.numberOfLines = 0
//        label.text = "500"
        
        label.font = label.font.withSize(12*factor!)
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    let walletView:UIView = {
        var view = UIView()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
//        view.layer.shadowRadius = 10
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var coinImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        imageView.frame = CGRect(x: 0, y: 0, width: 30*factor!, height: 30*factor!)
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var coinName:UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(16*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profitChange:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.textColor = UIColor.white
        label.font = UIFont.regularFont(12*factor!)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profitChangeNumber:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.textColor = UIColor.white
        label.font = UIFont.regularFont(12*factor!)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinAmount:UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(12*factor!)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinTotalPrice:UILabel = {
        var label = UILabel()
        label.text = "(--)"
        label.font = UIFont.regularFont(12*factor!)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var coinSinglePrice:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.font = UIFont.regularFont(16*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init Error")
    }
}

