//
//  WalletDetail.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 14/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation

class WalletDetail {
    var coinName:String = ""
    var coinAbbName:String = ""
    var coinAmount:Double = 0
    var TransactionPrice:Double = 0
    var TotalPrice:Double = 0
    var SinglePrice:Double = 0
    var riseFall:Double = 0
    var percent:String = "0"
    var tradingPairsName:String = ""
    var exchangeName:String = ""
    var logoUrl:String = ""
    var currentSinglePrice:Double = 0
    var currentTotalPrice:Double = 0
    var riseFallPrice:Double = 0
    var riseFallPercent:Double = 0
}

class CaculateResult {
    var single:Double = 0
    var total:Double = 0
    var profit:Double = 0
}
