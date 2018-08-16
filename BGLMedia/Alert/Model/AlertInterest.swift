//
//  AlertInterest.swift
//  BGLMedia
//
//  Created by Bruce Feng on 15/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift


class AlertInterest:Object{
    @objc dynamic var coinAbbName:String = ""
    @objc dynamic var coinName:String = ""
    @objc dynamic var available:Bool = false
    var everyAlert = List<EachInterest>()
    
    override class func primaryKey() -> String {
        return "coinAbbName"
    }
}


class EachInterest:Object{
    @objc dynamic var id:Int = 0
    @objc dynamic var coinName = ""
    @objc dynamic var coinAbbName = ""
    @objc dynamic var tradingPairs = ""
    @objc dynamic var exchangName = ""
    @objc dynamic var price:Double = 0
    @objc dynamic var compareStatus:Int = 0
    @objc dynamic var switchStatus:Bool = true
    @objc dynamic var dateTime = Date()
    
    override class func primaryKey() -> String {
        return "id"
    }
}
