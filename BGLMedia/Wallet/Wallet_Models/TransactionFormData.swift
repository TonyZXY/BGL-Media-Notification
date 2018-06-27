//
//  TransactionFormData.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation

class TransactionFormData{
    var coinName:String = ""
    var coinAbbName:String = ""
    var exchangesName:String = ""
    var tradingPairsNames:String = ""
    var tradingPairsFirst = [String]()
    var tradingPairsSecond = [String]()
    var tradingPrice:String = ""
    var transactionExpense:String = ""
    var transactionPrice:String = ""
    
    func clear(){
        coinName = ""
        coinAbbName = ""
        exchangesName = ""
        tradingPairsNames = ""
        tradingPairsFirst = []
        tradingPairsSecond = []
        tradingPrice = ""
        transactionExpense = ""
    }
    
}



