//
//  GameModels.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/4/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

struct User {
    let name: String
    var coinsBalance: [CoinBalance]
    
    init(name: String) {
        self.name = name
        coinsBalance = [CoinBalance]()
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
