//
//  GlobalCoinListCell.swift
//  BGLMedia
//
//  Created by Bruce Feng on 12/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher
//import RevealingSplashView


class GlobalCoinListCell:UICollectionViewCell{
    var color = ThemeColor()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    var priceChange: Double?
    
    var object: GlobalAverageObject? {
        didSet {
            var roundedPrice = object?.price ?? 0.0
            roundedPrice = round(roundedPrice * 100) / 100
            coinLabel.text = object?.coinAbbName
            coinNumber.text = currecyLogo[priceType]! + "\(roundedPrice)"
            coinType.text = textValue(name: "globalAverage_market")
//            coinChange.text = object?.percent7d
            rankLabel.text = String((object?.rank)!)
            coinImage.coinImageSetter(coinName: (object?.coinAbbName)!)
            
            let watchList = try! Realm().objects(WatchListRealm.self).filter("coinAbbName = %@", object!.coinAbbName)
            if watchList.count == 1 {
                addWish.setTitleColor(ThemeColor().blueColor(), for: .normal)
//                addWish.setTitle("★", for: .normal)
//                addWish.setClicked(true, animated: false)
//                addWish.color = ThemeColor().themeWidgetColor()
            } else {
                addWish.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
//                addWish.color = ThemeColor().textGreycolor()
//                addWish.setTitle("☆", for: .normal)
//                addWish.setClicked(false, animated: false)
            }
        }
    }
    
    let leftView:UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rankLabel:UILabel = {
       let label = UILabel()
        label.text = "1234"
        label.font = label.font.withSize(10)
        label.textColor = ThemeColor().textGreycolor()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let coinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = ThemeColor().whiteColor()
        label.font = label.font.withSize(18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coinChange:UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let coinType: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textAlignment = .left
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let coinNumber: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = ThemeColor().whiteColor()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addWish:UIButton = {
//        var param1 = WCLShineParams()
//        param1.bigShineColor = ThemeColor().themeWidgetColor()
//        param1.smallShineColor = ThemeColor().themeWidgetColor()
//        let bt1 = WCLShineButton(frame: .init(x:0, y:0, width: 20, height: 20), params: param1)
//        bt1.fillColor = ThemeColor().themeWidgetColor()
//        bt1.color = ThemeColor().textGreycolor()
//        bt1.translatesAutoresizingMaskIntoConstraints = false
//        bt1.image = .star

        let button = UIButton()
        button.setTitle("★", for: .normal)
        button.contentEdgeInsets.top = 20
        button.titleLabel?.font = button.titleLabel?.font.withSize(20)
        button.setTitleColor(ThemeColor().blueColor(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupView(){
        backgroundColor = color.walletCellcolor()
        addSubview(rankLabel)
        addSubview(coinImage)
        addSubview(coinLabel)
        addSubview(coinChange)
        addSubview(coinType)
        addSubview(coinNumber)
        addSubview(addWish)
        
        addWish.addTarget(self, action: #selector(addOrRemoveWatch), for: .touchUpInside)
        
        //coinImage
        //        self.layer.cornerRadius = self.frame.height / 4
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0(50)]-0-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
//        NSLayoutConstraint(item: addWish, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: rankLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        NSLayoutConstraint(item: coinImage, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: rankLabel, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addWish, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addWish, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addWish, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addWish, attribute: .right, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: .left, multiplier: 1, constant: 0).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2]-5-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        NSLayoutConstraint(item: coinLabel, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinLabel, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: .top, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v2]-5-[v4]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        NSLayoutConstraint(item: coinType, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinType, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0).isActive = true
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]-5-[v5]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        NSLayoutConstraint(item: coinNumber, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinNumber, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: .top, multiplier: 1, constant: 0).isActive = true

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v4]-5-[v6]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":rankLabel,"v1":addWish,"v2":coinImage,"v3":coinLabel,"v4":coinType,"v5":coinNumber,"v6":coinChange]))
        NSLayoutConstraint(item: coinChange, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinChange, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: coinImage, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinLabel, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: coinType, attribute: .left, multiplier: 1, constant: 0).isActive = true
         NSLayoutConstraint(item: coinNumber, attribute: .right, relatedBy: NSLayoutRelation.equal, toItem: coinChange, attribute: .right, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init Error")
    }
    
    @objc func addOrRemoveWatch(sender: UIButton) {
        let realm = try! Realm()
        print(object!.coinAbbName)
        let watchList = try! Realm().objects(WatchListRealm.self).filter("coinAbbName = %@", object!.coinAbbName)
        realm.beginWrite()
        if watchList.count == 1 {
//            addWish.setClicked(false)
//            addWish.setClicked(false, animated: true)
//            addWish.color = ThemeColor().textGreycolor()
//            addWish.setTitle("☆", for: .normal)
            addWish.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
            realm.delete(watchList[0])
        } else {
//            addWish.setClicked(true)
//            addWish.setClicked(true, animated: true)
//            addWish.setTitle("★", for: .normal)
            addWish.setTitleColor(ThemeColor().blueColor(), for: .normal)
            realm.create(WatchListRealm.self, value: [object!.coinAbbName, object!.coinName,"Global Average",priceType,object!.price,object!.percent24h,true])
        }
        try! realm.commitWrite()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeWatchList"), object: nil)
    }
}

