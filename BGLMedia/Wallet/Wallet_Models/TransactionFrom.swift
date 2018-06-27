//
//  TransactionFromProtocol.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation

protocol TransactionFrom:class{
    func setCoinName(name:String)
    func setCoinAbbName(abbName:String)
    func setExchangesName(exchangeName:String)
    func setTradingPairsName(tradingPairsName:String)
    func setTradingPairsFirstType(firstCoinType:[String])
    func setTradingPairsSecondType(secondCoinType:[String])
    func getExchangeName()->String
    func getCoinName()->String
}
