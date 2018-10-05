//
//  GameModels.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/4/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GameUser {
    let name: String
    var coinsBalance: [CoinBalance]
    
    init(name: String) {
        self.name = name
        coinsBalance = [CoinBalance]()
    }
    
    init(_ json: JSON) {
        print(json)
        self.name = json["nick_name"].stringValue
        print(222222)
        print(name)
        coinsBalance = [CoinBalance]()
        initialSetup(json)
    }
    
    private mutating func initialSetup(_ json: JSON) {
        let aud = CoinBalance(name: "AUD", amount: json["aud"].doubleValue)
        coinsBalance.append(aud)
        let btc = CoinBalance(name: "Bitcoin", amount: json["btc"].doubleValue)
        coinsBalance.append(btc)
        let eth = CoinBalance(name: "Ethereum", amount: json["eth"].doubleValue)
        coinsBalance.append(eth)
        let bch = CoinBalance(name: "Bitcoin Cash", amount: json["bch"].doubleValue)
        coinsBalance.append(bch)
        let ltc = CoinBalance(name: "Litecoin", amount: json["ltc"].doubleValue)
        coinsBalance.append(ltc)
        let etc = CoinBalance(name: "Ethereum Classic", amount: json["etc"].doubleValue)
        coinsBalance.append(etc)
        let powr = CoinBalance(name: "Power Ledger", amount: json["powr"].doubleValue)
        coinsBalance.append(powr)
        let elf = CoinBalance(name: "aelf", amount: json["elf"].doubleValue)
        coinsBalance.append(elf)
        let ctxc = CoinBalance(name: "Cortex", amount: json["ctxc"].doubleValue)
        coinsBalance.append(ctxc)
        let dta = CoinBalance(name: "Data", amount: json["dta"].doubleValue)
        coinsBalance.append(dta)
        let iost = CoinBalance(name: "IOS token", amount: json["iost"].doubleValue)
        coinsBalance.append(iost)
    }
}

struct CoinBalance {
    let name: String
    let amount: Double
    
    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
}
