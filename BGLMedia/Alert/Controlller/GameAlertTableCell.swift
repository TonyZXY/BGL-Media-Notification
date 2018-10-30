//
//  GameAlertTableCell.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 23/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GameAlertTableCell: UITableViewCell {
    var changeSwitchStatus = false
    var factor:CGFloat?{
        didSet{
            setUpView()
        }
    }
    
    var object:GameAlertObject?{
        didSet{
            var compare:String = ""
            if object?.compareStatus == 1{
                compare = ">"
            }else if object?.compareStatus == 2{
                compare = "<"
            } else {
                compare = "="
            }
            let compareLabels = "1 " + (object?.coinAbbName)! + " " + compare + " " +  Extension.method.scientificMethod(number: (object?.inputPrice)!) + " AUD"
            let exchangeName = "Huobi Australia"
            
            let coinDetail = exchangeName + " - " + (object?.coinAbbName.uppercased())! + "/AUD"
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
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func setUpView(){
        compareLabel.font = UIFont.regularFont(18*factor!)
        dateLabel.font = UIFont.regularFont(11*factor!)
        coinDetailLabel.font = UIFont.regularFont(11*factor!)
        addSubview(swithButton)
        addSubview(compareLabel)
        //        addSubview(dateLabel)
        addSubview(coinDetailLabel)
        backgroundColor = ThemeColor().greyColor()
        swithButton.addTarget(self, action: #selector(switchIsInAction), for: .touchUpInside)
        
        NSLayoutConstraint(item: swithButton, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: swithButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: compareLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: compareLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
        
        
        
        //        NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        //        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(5*factor!)-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":compareLabel]))
        NSLayoutConstraint(item: coinDetailLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinDetailLabel, attribute: .top, relatedBy: .equal, toItem: compareLabel, attribute: .bottom, multiplier: 1, constant: 2).isActive = true
        
        //        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-\(5*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailLabel,"v1":compareLabel]))
        
    }
    
    
    var swithButton:UISwitch = {
        var switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        return switchButton
    }()
    
    @objc func switchIsInAction(sender:UISwitch){
        let realm = try! Realm()
        let alertStatus = try! Realm().objects(GameAlertObject.self).filter("id = %@", object?.id ?? 0)
        
        if let object = alertStatus.first{
            try! realm.write {
                if swithButton.isOn{
                    object.switchStatus = true
                } else{
                    object.switchStatus = false
                }
            }
        }
        
    }
    
    var compareLabel:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(20)
        label.textColor = ThemeColor().whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var coinDetailLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
