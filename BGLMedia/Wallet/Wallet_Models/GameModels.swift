//
//  GameModels.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/4/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

struct GameUser {
    let id : String
    let name: String
    var coins: [GameCoin]
    
    init(_ json: JSON) {
        id = json["data"]["user_id"].stringValue
        name = json["data"]["nick_name"].stringValue
        coins = [GameCoin]()
        updateCoinsBalance(json["data"])
    }
    
    mutating func updateCoinsBalance(_ json: JSON) {
        let audAmount = json["aud"].doubleValue
        let btcAmount = json["btc"].doubleValue
        let ethAmount = json["eth"].doubleValue
        let bchAmount = json["bch"].doubleValue
        let ltcAmount = json["ltc"].doubleValue
        let etcAmount = json["etc"].doubleValue
        let powrAmount = json["powr"].doubleValue
        let elfAmount = json["elf"].doubleValue
        let ctxcAmount = json["ctxc"].doubleValue
        let dtaAmount = json["dta"].doubleValue
        let iostAmount = json["iost"].doubleValue
        
        coins.removeAll()
        if audAmount > 0 {
            let coin = GameCoin(name: "AUD", abbrName: "AUD", amount: audAmount)
            coins.append(coin)
        }
        if btcAmount > 0 {
            let coin = GameCoin(name: "Bitcoin", abbrName: "BTC", amount: btcAmount)
            coins.append(coin)
        }
        if ethAmount > 0 {
            let coin = GameCoin(name: "Ethereum", abbrName: "ETH", amount: ethAmount)
            coins.append(coin)
        }
        if bchAmount > 0 {
            let coin = GameCoin(name: "Bitcoin Cash", abbrName: "BCH", amount: bchAmount)
            coins.append(coin)
        }
        if ltcAmount > 0 {
            let coin = GameCoin(name: "Litecoin", abbrName: "LTC", amount: ltcAmount)
            coins.append(coin)
        }
        if etcAmount > 0 {
            let coin = GameCoin(name: "Ethereum Classic", abbrName: "ETC", amount: etcAmount)
            coins.append(coin)
        }
        if powrAmount > 0 {
            let coin = GameCoin(name: "Power Ledger", abbrName: "POWR", amount: powrAmount)
            coins.append(coin)
        }
        if elfAmount > 0 {
            let coin = GameCoin(name: "aelf", abbrName: "ELF", amount: elfAmount)
            coins.append(coin)
        }
        if ctxcAmount > 0 {
            let coin = GameCoin(name: "Cortex", abbrName: "CTXC", amount: ctxcAmount)
            coins.append(coin)
        }
        if dtaAmount > 0 {
            let coin = GameCoin(name: "Data", abbrName: "DTA", amount: dtaAmount)
            coins.append(coin)
        }
        if iostAmount > 0 {
            let coin = GameCoin(name: "IOS token", abbrName: "IOST", amount: iostAmount)
            coins.append(coin)
        }
    }
}

struct GameCoin {
    let name: String
    let abbrName: String
    let amount: Double
    var price: Double
    var totalValueOfBuy: Double
    var totalAmountOfBuy: Double
    var totalValueOfSell: Double
    var totalAmountOfSell: Double
    
    init(name: String, abbrName: String, amount: Double) {
        self.name = name
        self.abbrName = abbrName
        self.amount = amount
        price = 0
        totalValueOfBuy = 0
        totalAmountOfBuy = 0
        totalValueOfSell = 0
        totalAmountOfSell = 0
    }
}

struct TransSum {
    let abbrName: String
    let status: String
    let totalAmount: Double
    let totalValue: Double
    
    init(_ json: JSON) {
        abbrName = json["coin_add_name"].stringValue
        status = json["status"].stringValue
        totalAmount = json["total_amount"].doubleValue
        totalValue = json["total_value"].doubleValue
    }
}


class GameTransaction:Object{
    @objc dynamic var transaction_id :String = "0"
    @objc dynamic var user_id :String = "0"
    @objc dynamic var status :String = ""
    @objc dynamic var coin_name : String = ""
    @objc dynamic var coin_abb_name : String = ""
    @objc dynamic var exchange_name : String = ""
    @objc dynamic var trading_pair_name : String = ""
    @objc dynamic var single_price : Double = 0
    @objc dynamic var amount : Double = 0
    
    
    enum TransactionStatus : String{
        case SELL = "sell"
        case BUY = "buy"
    }
    
    override class func primaryKey() -> String {
        return "transaction_id"
    }
}
