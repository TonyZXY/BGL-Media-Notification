//
//  MarketsCoinListTableView.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 1/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class MarketsCoinTableViewCell:UITableViewCell{
    var color = ThemeColor()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let coinLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coinChange:UILabel = {
        let label = UILabel()
        label.text = "+4.98%"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coinType: UILabel = {
        let label = UILabel()
        label.text = "全球市场平均价"
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coinNumber: UILabel = {
        let label = UILabel()
        label.text = "$11345"
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addWish:UIButton = {
        let button = UIButton()
        button.setTitle("★", for: .normal)
        button.setTitleColor(UIColor.yellow, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupviews(){
        addSubview(coinImage)
        addSubview(coinLabel)
        addSubview(coinChange)
        addSubview(coinType)
        addSubview(coinNumber)
        addSubview(addWish)
        self.selectionStyle = .none
        
        coinType.text = textValue(name: "globalAverage_market")
        addWish.addTarget(self, action: #selector(MarketsCoinTableViewCell.removeWatch), for: .touchUpInside)
        
        //coinImage
        self.layer.cornerRadius = self.frame.height / 4
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinLabel,"v3":coinChange,"v4":coinType,"v5":coinNumber]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinLabel,"v3":coinChange,"v4":coinType,"v5":coinNumber]))
        NSLayoutConstraint(item: coinImage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        //coinLabel
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-5-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinLabel,"v2":coinChange,"v3":coinType,"v4":coinNumber]))
        NSLayoutConstraint(item: coinLabel, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        //coinType
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-5-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinLabel,"v2":coinChange,"v3":coinType,"v4":coinNumber]))
        NSLayoutConstraint(item: coinType, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        //coinChange
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2]-5-[v5]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinLabel,"v2":coinChange,"v3":coinType,"v4":coinNumber,"v5":addWish]))
        NSLayoutConstraint(item: coinChange, attribute:.centerY , relatedBy: NSLayoutRelation.equal, toItem: coinLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        //coinNunmber
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v4]-5-[v5]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinLabel,"v2":coinChange,"v3":coinType,"v4":coinNumber,"v5":addWish]))
        NSLayoutConstraint(item: coinNumber, attribute:.centerY , relatedBy: NSLayoutRelation.equal, toItem: coinType, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        //addWish Button
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v5]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage,"v1":coinLabel,"v2":coinChange,"v3":coinType,"v4":coinNumber,"v5":addWish]))
        NSLayoutConstraint(item: addWish, attribute:.centerY , relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func removeWatch(sender: UIButton) {
        let realm = try! Realm()
        let watchList = realm.objects(CoinsInWatchListRealm.self).filter("symbol = %@", object!.symbol)
        realm.beginWrite()
        realm.delete(watchList[0])
        try! realm.commitWrite()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateWatchInWatchList"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeWatchInMarketsCell"), object: nil)
    }
    
    var priceChange: Double?
    
    var object: TickerDataRealm? {
        didSet {
            var roundedPrice = object?.price ?? 0.0
            roundedPrice = round(roundedPrice * 100) / 100
            coinLabel.text = object?.symbol
            coinNumber.text = currecyLogo[priceType]! + "\(roundedPrice)"
            coinChange.text = "\(priceChange ?? 0.0)"
            
            coinImage.coinImageSetter(coinName: object!.symbol)
            
            guard let percentChange = priceChange else { return }
            if percentChange > 0.0 {
                coinChange.textColor = color.riseColor()
            } else if percentChange == 0.0 {
                coinChange.textColor = .white
            } else {
                coinChange.textColor = color.fallColor()
            }
        }
    }
}
