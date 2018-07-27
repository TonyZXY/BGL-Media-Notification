//
//  WatchListRealm.swift
//  BGLMedia
//
//  Created by Bruce Feng on 12/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift

class WatchListRealm: Object {
    @objc dynamic var coinAbbName = ""
    @objc dynamic var coinName = ""
    @objc dynamic var market = ""
    @objc dynamic var tradingPairsName = ""
    @objc dynamic var price:Double = 0
    @objc dynamic var profitChange:Double = 0
    @objc dynamic var isGlobalAverage:Bool = true
    @objc dynamic var rank:Int = 0
    @objc dynamic var date = Date()
    
    
    override class func primaryKey() -> String {
        return "coinAbbName"
    }
}
