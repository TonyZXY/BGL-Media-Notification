//
//  Transactions.swift
//  BGLMedia
//
//  Created by Bruce Feng on 29/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift

class Transactions:Object{
    @objc dynamic var coinName = ""
    @objc dynamic var coinAbbName = ""
    @objc dynamic var transactionPrice:Double = 0
    @objc dynamic var exchangeName = ""
    @objc dynamic var tradingPairsName = ""
    @objc dynamic var currentSinglePrice:Double = 0
    @objc dynamic var currentTotalPrice:Double = 0
    @objc dynamic var totalRiseFallPercent:Double = 0
    @objc dynamic var totalRiseFallNumber:Double = 0
    @objc dynamic var totalAmount:Double = 0
    var everyTransactions = List<EachTransactions>()
    
    override class func primaryKey() -> String {
        return "coinAbbName"
    }
}

class EachTransactions:Object{
    @objc dynamic var id:Int = 0
    @objc dynamic var status = ""
    @objc dynamic var coinName = ""
    @objc dynamic var coinAbbName = ""
    @objc dynamic var exchangeName = ""
    @objc dynamic var tradingPairsName = ""
    @objc dynamic var singlePrice:Double = 0
    @objc dynamic var totalPrice:Double = 0
    @objc dynamic var amount:Double = 0
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var expenses = ""
    @objc dynamic var additional = ""
    var currency = List<EachCurrency>()
   
    override class func primaryKey() -> String {
        return "id"
    }
}

class EachCurrency:Object{
    @objc dynamic var name:String = ""
    @objc dynamic var price:Double = 0
}
