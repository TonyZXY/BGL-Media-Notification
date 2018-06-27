//
//  AllTransactions.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 13/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

class AllTransactions:Object{
    @objc dynamic var id:Int = 0
    @objc dynamic var status = ""
    @objc dynamic var coinName = ""
    @objc dynamic var coinAbbName = ""
    @objc dynamic var exchangName = ""
    @objc dynamic var tradingPairsName = ""
    @objc dynamic var singlePrice:Double = 0
    @objc dynamic var totalPrice:Double = 0
    @objc dynamic var amount:Double = 0
    @objc dynamic var date = ""
    @objc dynamic var time = ""
    @objc dynamic var expenses = ""
    @objc dynamic var additional = ""
    @objc dynamic var usdSinglePrice:Double = 0
    @objc dynamic var usdTotalPrice:Double = 0
    @objc dynamic var audSinglePrice:Double = 0
    @objc dynamic var audTotalPrice:Double = 0
    var currency = List<Currencys>()
    
    override class func primaryKey() -> String {
        return "id"
    }
}

class Currencys:Object{
    @objc dynamic var name:String = ""
    @objc dynamic var price:Double = 0
}
