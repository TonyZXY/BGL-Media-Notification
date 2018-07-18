//
//  ChangeRiseFallColor.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 25/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit

var priceType:String {
    get{
        var curreny:String = ""
        if let defaultCurrency = UserDefaults.standard.value(forKey: "defaultCurrency") as? String{
            curreny = defaultCurrency
            return curreny
        } else {
            return curreny
        }
    }
}


var currecyLogo:[String:String] {
    get{
        return ["AUD":"A$","JPY":"¥","USD":"$","CNY":"¥","EUR":"€"]
    }
}


var currencyName:[String:String] {
    get{
        return ["AUD":"AUD","JPY":"JPY","USD":"USD","CNY":"RMB","EUR":"EUR"]
    }
}


