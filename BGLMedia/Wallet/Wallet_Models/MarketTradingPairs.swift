//
//  MarketTradingPairs.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 24/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

class MarketTradingPairs:Object{
    @objc dynamic var coinName:String = ""
    @objc dynamic var coinAbbName:String = ""
    @objc dynamic var exchangeName:String = ""
    @objc dynamic var tradingPairsName:String = ""
    @objc dynamic var coinAmount:Double = 0
    @objc dynamic var totalRiseFall:Double = 0
    @objc dynamic var singlePrice:Double = 0
    @objc dynamic var totalPrice:Double = 0
    @objc dynamic var totalRiseFallPercent:Double = 0
    @objc dynamic var transactionPrice:Double = 0
    @objc dynamic var priceType:String = ""
    
    override class func primaryKey() -> String {
            return "coinAbbName"
    }
}
