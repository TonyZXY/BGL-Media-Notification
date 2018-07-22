//
//  ExchangeSelect.swift
//  BGLMedia
//
//  Created by Bruce Feng on 22/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation


protocol ExchangeSelect:class{
    func setExchangesName(exchangeName:String)
    func setTradingPairs(tradingPair:String)
}

protocol TradingPairsSelect:class{
    func setTradingPairs(tradingPair:String)
}
