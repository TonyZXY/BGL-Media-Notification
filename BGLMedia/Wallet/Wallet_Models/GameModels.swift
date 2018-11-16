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
    var competitionStartingAsset : Double
    var totalBalance : Double {
        var total = 0.0
        coins.forEach({ (coin) in
            total += coin.amount * coin.price
        })
        return total
    }
    
    init(_ json: JSON) {
        id = json["data"]["user_id"].stringValue
        name = json["data"]["nick_name"].stringValue
        competitionStartingAsset = Double(json["data"]["last_week"].stringValue) ?? 0
        coins = [GameCoin]()
        setupCoins(json["data"])
    }
    
    mutating func setupCoins(_ json: JSON) {
        let audAmount = Double(json["aud"].stringValue) ?? 0
        let btcAmount = Double(json["btc"].stringValue) ?? 0
        let ethAmount = Double(json["eth"].stringValue) ?? 0
        let bchAmount = Double(json["bch"].stringValue) ?? 0
        let ltcAmount = Double(json["ltc"].stringValue) ?? 0
        let etcAmount = Double(json["etc"].stringValue) ?? 0
        let powrAmount = Double(json["powr"].stringValue) ?? 0
        let elfAmount = Double(json["elf"].stringValue) ?? 0
        let ctxcAmount = Double(json["ctxc"].stringValue) ?? 0
        let dtaAmount = Double(json["dta"].stringValue) ?? 0
        let iostAmount = Double(json["iost"].stringValue) ?? 0
        
        coins.removeAll()
        coins.append(GameCoin(name: "AUD", abbrName: "AUD", amount: audAmount))
        coins.append(GameCoin(name: "Bitcoin", abbrName: "BTC", amount: btcAmount))
        coins.append(GameCoin(name: "Ethereum", abbrName: "ETH", amount: ethAmount))
        coins.append(GameCoin(name: "Bitcoin Cash", abbrName: "BCH", amount: bchAmount))
        coins.append(GameCoin(name: "Litecoin", abbrName: "LTC", amount: ltcAmount))
        coins.append(GameCoin(name: "Ethereum Classic", abbrName: "ETC", amount: etcAmount))
        coins.append(GameCoin(name: "Power Ledger", abbrName: "POWR", amount: powrAmount))
        coins.append(GameCoin(name: "aelf", abbrName: "ELF", amount: elfAmount))
        coins.append(GameCoin(name: "Cortex", abbrName: "CTXC", amount: ctxcAmount))
        coins.append(GameCoin(name: "Data", abbrName: "DTA", amount: dtaAmount))
        coins.append(GameCoin(name: "IOS token", abbrName: "IOST", amount: iostAmount))
    }
    
    mutating func updateCoinsAmount(_ json: JSON) {
        for (index, _) in coins.enumerated() {
            if coins[index].abbrName == "AUD" {
                coins[index].amount = Double(json["aud"].stringValue) ?? 0
            }
            if coins[index].abbrName == "BTC" {
                coins[index].amount = Double(json["btc"].stringValue) ?? 0
            }
            if coins[index].abbrName == "ETH" {
                coins[index].amount = Double(json["eth"].stringValue) ?? 0
            }
            if coins[index].abbrName == "BCH" {
                coins[index].amount = Double(json["bch"].stringValue) ?? 0
            }
            if coins[index].abbrName == "LTC" {
                coins[index].amount = Double(json["ltc"].stringValue) ?? 0
            }
            if coins[index].abbrName == "ETC" {
                coins[index].amount = Double(json["etc"].stringValue) ?? 0
            }
            if coins[index].abbrName == "POWR" {
                coins[index].amount = Double(json["powr"].stringValue) ?? 0
            }
            if coins[index].abbrName == "ELF" {
                coins[index].amount = Double(json["elf"].stringValue) ?? 0
            }
            if coins[index].abbrName == "CTXC" {
                coins[index].amount = Double(json["ctxc"].stringValue) ?? 0
            }
            if coins[index].abbrName == "DTA" {
                coins[index].amount = Double(json["dta"].stringValue) ?? 0
            }
            if coins[index].abbrName == "IOST" {
                coins[index].amount = Double(json["iost"].stringValue) ?? 0
            }
        }
    }
}

struct GameCoin {
    let name: String
    let abbrName: String
    var amount: Double
    var price: Double
    var exchangeName : String = "Huobi Australia"
    var tradingPairName : String = "AUD"
    var totalValueOfBuy: Double
    var totalAmountOfBuy: Double
    var totalValueOfSell: Double
    var totalAmountOfSell: Double
    var totalValue: Double { return amount * price }
    var avgOfBuyPrice: Double { return totalAmountOfBuy == 0 ? 0 : totalValueOfBuy / totalAmountOfBuy }
    var leftTransactionAmount: Double { return totalAmountOfBuy - totalAmountOfSell }
    var profitNumber: Double {
        if abbrName == "AUD" { return 0 }
        return totalValue - totalValueOfBuy
    }
    var profitPercentage: Double { return totalValueOfBuy == 0 ? 0 : profitNumber * 100 / totalValueOfBuy }
    var realisedProfitNumber: Double
    var netValue : Double {return avgOfBuyPrice * leftTransactionAmount}
    var transactions = [GameCoinTransaction]()
    
    init(name: String, abbrName: String, amount: Double) {
        self.name = name
        self.abbrName = abbrName
        self.amount = amount
        price = 0
        totalValueOfBuy = 0
        totalAmountOfBuy = 0
        totalValueOfSell = 0
        totalAmountOfSell = 0
        realisedProfitNumber = 0
    }
    
    mutating func updateTransactions(_ jsonArray: [JSON]) {
        transactions.removeAll()
        jsonArray.forEach { (json) in
            let transaction = GameCoinTransaction(json)
            transactions.append(transaction)
        }
        transactions.sort { $0.date < $1.date }
        calculateProfits()
    }
    
    private mutating func calculateProfits() {
        totalValueOfBuy = 0
        totalAmountOfBuy = 0
        realisedProfitNumber = 0
        transactions.forEach { (transaction) in
            if transaction.status.lowercased() == "buy" {
                totalAmountOfBuy += transaction.tradeAmount
                totalValueOfBuy += transaction.tradePrice * transaction.tradeAmount / (1 - transactionFee)
            } else {
                realisedProfitNumber = realisedProfitNumber + transaction.tradePrice * transaction.tradeAmount * (1 - transactionFee) - avgOfBuyPrice * transaction.tradeAmount
                totalValueOfBuy = totalValueOfBuy - avgOfBuyPrice * transaction.tradeAmount
                totalAmountOfBuy -= transaction.tradeAmount
                totalAmountOfBuy += 0.000000001
                totalAmountOfBuy = totalAmountOfBuy.floorTo(decimalLimit: 8)
                if totalAmountOfBuy == 0 {
                    totalValueOfBuy = 0 //solve double problem
                }
            }
        }
    }
}

struct GameCoinTransaction {
    let id: String
    let status: String
    let tradePrice: Double
    let tradeAmount: Double
    let date: Date
    let note: String
    
    init(_ json: JSON) {
        id = json["transaction_id"].stringValue
        status = json["status"].stringValue
        tradePrice = Double(json["single_price"].stringValue) ?? 0
        tradeAmount = Double(json["amount"].stringValue) ?? 0
        date = Extension.method.convertStringToDate(date: json["date"].stringValue)
        note = json["note"].stringValue
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


//class GameTransaction:Object{
//    @objc dynamic var transaction_id :String = "0"
//    @objc dynamic var user_id :String = "0"
//    @objc dynamic var status :String = ""
//    @objc dynamic var coin_name : String = ""
//    @objc dynamic var coin_abb_name : String = ""
//    @objc dynamic var exchange_name : String = ""
//    @objc dynamic var trading_pair_name : String = ""
//    @objc dynamic var single_price : Double = 0
//    @objc dynamic var amount : Double = 0
//
//
//    enum TransactionStatus : String{
//        case SELL = "sell"
//        case BUY = "buy"
//    }
//
//    override class func primaryKey() -> String {
//        return "transaction_id"
//    }
//}
