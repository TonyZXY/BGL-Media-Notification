//
//  GameModels.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/4/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

struct GameUser {
    let name: String
    var coinsBalance: [CoinBalance]
    
    init(name: String) {
        self.name = name
        coinsBalance = [CoinBalance]()
        initialSetup()
    }
    
    private mutating func initialSetup() {
        let aud = CoinBalance(name: "AUD", amount: 1000000)
        coinsBalance.append(aud)
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
