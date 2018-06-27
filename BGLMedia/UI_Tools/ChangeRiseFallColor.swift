//
//  ChangeRiseFallColor.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 25/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
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
    
    func checkDataRiseFallColor(risefallnumber: Double,label:UILabel,type:String) {
//        let currecyLogo = ["AUD":"A$","JPY":"JP¥","USD":"$","CNY":"RMB¥","EUR":"€"]
        
        if type == "Default"{
            label.textColor = UIColor.white
            label.text = currecyLogo[priceType]! + scientificMethod(number: risefallnumber)
        } else {
            if String(risefallnumber).prefix(1) == "-" {
                // lost with red
                label.textColor = ThemeColor().fallColor()
                if type == "Percent"{
                    label.text = scientificMethod(number: risefallnumber) + "%"
                } else{
                    label.text = "▼ " + currecyLogo[priceType]! + scientificMethod(number: risefallnumber)
                }
            } else if String(risefallnumber) == "0.0"{
                // Not any change with white
                label.text = "--"
                label.textColor = UIColor.white
            } else {
                //Profit with green
                label.textColor = ThemeColor().riseColor()
                if type == "Percent"{
                    label.text =  scientificMethod(number: risefallnumber) + "%"
                } else{
                    label.text = "▲ " + currecyLogo[priceType]! + scientificMethod(number: risefallnumber)
                }
            }
        }
    }
}
