//
//  GlobalAverageObject.swift
//  BGLMedia
//
//  Created by Bruce Feng on 11/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift

class GlobalAverageObject: Object {
    @objc dynamic var id:String = ""
    @objc dynamic var coinId:Int = 0
    @objc dynamic var coinAbbName:String = ""
    @objc dynamic var coinName:String = ""
    @objc dynamic var totalSupply:Double = 0.0
    @objc dynamic var circulatingSupply:Double = 0.0
    @objc dynamic var currency:String = ""
    @objc dynamic var percent24h:Double = 0.0
    @objc dynamic var percent1h:Double = 0.0
    @objc dynamic var percent7d:Double = 0.0
    @objc dynamic var volume24:Double = 0.0
    @objc dynamic var max_supply:Double = 0.0
    @objc dynamic var marketCap:Double = 0.0
    @objc dynamic var price:Double = 0.0
    @objc dynamic var rank:Int = 0
    
    
    
    override class func primaryKey() -> String {
        return "coinAbbName"
    }
}
