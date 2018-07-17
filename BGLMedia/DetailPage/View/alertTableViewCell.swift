//
//  alertTableViewCell.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 26/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AlertTableViewCell:UITableViewCell{
    

    var object:alertObject?{
        didSet{
            var compare:String = ""
            if object?.compareStatus == 1{
                compare = ">"
            }else if object?.compareStatus == 2{
                compare = "<"
            } else {
                compare = "="
            }
            let compareLabels = "1 " + (object?.coinAbbName)! + " " + compare + " " + String((object?.price)!)
            let coinDetail = (object?.exchangName)! + " - " + (object?.coinAbbName)! + "/" + (object?.tradingPairs)!
            let dateToString = DateFormatter()
            dateToString.dateFormat = "EEEE, dd MMMM yyyy HH:mm"
            dateToString.locale = Locale(identifier: "en_AU")
            let times = dateToString.string(from: (object?.dateTime)!)
            dateLabel.text = times
            compareLabel.text = compareLabels
            coinDetailLabel.text = coinDetail
            swithButton.isOn = (object?.switchStatus)!
        }
    }
//        didSet{
//
//        }
//
//    var object: alertObject? {
//        didSet {
//            var roundedPrice = object?.price ?? 0.0
//            roundedPrice = round(roundedPrice * 100) / 100
//
//
//
//            coinLabel.text = object?.coinAbbName
//            coinNumber.text = currecyLogo[priceType]! + "\(roundedPrice)"
//            //            coinChange.text = object?.percent7d
//            coinImage.coinImageSetter(coinName: (object?.coinAbbName)!)
//
//            let watchList = try! Realm().objects(WatchListRealm.self).filter("coinAbbName = %@", object!.coinAbbName)
//            if watchList.count == 1 {
//                addWish.setTitle("★", for: .normal)
//            } else {
//                addWish.setTitle("☆", for: .normal)
//            }
//        }
//    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func setUpView(){
        addSubview(swithButton)
        addSubview(compareLabel)
        addSubview(dateLabel)
        addSubview(coinDetailLabel)
        
        swithButton.addTarget(self, action: #selector(switchIsInAction), for: .touchUpInside)
        
        NSLayoutConstraint(item: swithButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: swithButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: compareLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: compareLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-5-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":compareLabel]))
        NSLayoutConstraint(item: coinDetailLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailLabel,"v1":compareLabel]))
        
    }
    
    
    var swithButton:UISwitch = {
        var switchButton = UISwitch()
//        switchButton.isOn = false
//        switchButton.thumbTintColor = UIColor.red
//        switchButton.tintColor = UIColor.green
//        switchButton.onTintColor = ThemeColor().bglColor()
//        switchButton.addTarget(self, action: #selector(switchIsInAction), for: .touchUpInside)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    @objc func switchIsInAction(sender:UISwitch){
        let realm = try! Realm()
        
        let alertStatus = try! Realm().objects(alertObject.self).filter("id = %@", object?.id ?? 0)
        
        if let object = alertStatus.first{
                try! realm.write {
                    if swithButton.isOn{
                         object.switchStatus = true
                    } else{
                        object.switchStatus = false
                    }
                }
        }
        
            print(alertStatus)
        
//        realm.beginWrite()
//        if alertStatus.count == 1{
//            if alertStatus[0].switchStatus{
//
//            }
//        }
//
//        try! realm.commitWrite()
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGlobalMarket"), object: nil)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
    }
    
    var compareLabel:UILabel = {
       var label = UILabel()
        label.text = "haha"
        label.font = label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel:UILabel = {
        var label = UILabel()
        label.text = "haha"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var coinDetailLabel:UILabel = {
        var label = UILabel()
        label.text = "haha"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
