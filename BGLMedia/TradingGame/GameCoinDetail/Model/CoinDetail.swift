//
//  CoinDetail.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 11/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift

class GameCoinDetail:Object{
    @objc dynamic var coinName = ""
    @objc dynamic var coinAbbName = ""
    @objc dynamic var transactionPrice:Double = 0
    @objc dynamic var exchangeName = ""
    @objc dynamic var tradingPairsName = ""
    @objc dynamic var defaultCurrencyPrice:Double = 0
    @objc dynamic var defaultTotalPrice:Double = 0
    @objc dynamic var totalRiseFallPercent:Double = 0
    @objc dynamic var totalRiseFallNumber:Double = 0
    @objc dynamic var totalAmount:Double = 0
    @objc dynamic var publishDate = Date()
//    var everyTransactions = List<EachTransactions>()
    @objc dynamic var currentSinglePrice:Double = 0
    @objc dynamic var currentTotalPrice:Double = 0
    @objc dynamic var currentNetValue:Double = 0
    @objc dynamic var currentRiseFall:Double = 0
    @objc dynamic var floatingPrice:Double = 0
    @objc dynamic var floatingPercent:Double = 0
    @objc dynamic var unrealizedPrice:Double = 0
    
    override class func primaryKey() -> String {
        return "coinAbbName"
    }
}
