//
//  GetDataServices.swift
//  BGLMedia
//
//  Created by Bruce Feng on 4/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import Realm
import SwiftyJSON
import Alamofire
import RealmSwift
import JGProgressHUD
import SwiftKeychainWrapper

class RefreshDataService:NSObject{
    static let refresh = RefreshDataService()
    
    func caculateAssetsData(coinAbbName:String,completion:@escaping (Bool)->Void){
        var amount:Double = 0
        var transactionPrice:Double = 0
        var singlePrice:Double = 0
        var currency:Double = 0
        var singleAverageBuyPrice:Double = 0
        var buyTotalPrice:Double = 0
        var buyAmount:Double = 0
        var sellTotalPrice:Double = 0
        var totalAmount:Double = 0
        var floatingPrice:Double = 0
        var unrealizedPrice:Double = 0
        
        let totalAssets = try! Realm().objects(Transactions.self).filter("coinAbbName = %@", coinAbbName)
        
        
        if let result = totalAssets.first{
            //            print(result.everyTransactions)
            for each in result.everyTransactions{
                let currencyResult = each.currency.filter{name in return name.name.contains(priceType)}
                if each.status == "Buy"{
                    buyAmount += each.amount
                    totalAmount += each.amount
                    buyTotalPrice += ((each.amount) * (currencyResult.first?.price ?? 0))
                }
                else if each.status == "Sell"{
                    totalAmount -= each.amount
                }
            }
            
            singleAverageBuyPrice = buyTotalPrice / buyAmount
            
            
            for each in result.everyTransactions{
                let currencyResult = each.currency.filter{name in return name.name.contains(priceType)}
                if each.status == "Sell"{
                    sellTotalPrice += (((currencyResult.first?.price ?? 0)) - singleAverageBuyPrice) * each.amount
                }
            }
            
            unrealizedPrice = sellTotalPrice
            
            for each in result.everyTransactions{
                let currencyResult = each.currency.filter{name in return name.name.contains(priceType)}
                if each.status == "Buy"{
                    amount += each.amount
                    transactionPrice += ((each.amount) * (currencyResult.first?.price ?? 0))
                } else if each.status == "Sell"{
                    amount -= each.amount
                    transactionPrice -= ((each.amount) * (currencyResult.first?.price ?? 0))
                }
            }
            
            
            if result.exchangeName == "Global Average"{
                URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoin?coin=" + result.coinAbbName], httpMethod: "GET", parameters: [String : Any]()) { (response, success) in
                    if success{
                        if let responseResult = response["quotes"].array{
                            for results in responseResult{
                                if results["currency"].string ?? "" == priceType{
                                    singlePrice = results["data"]["price"].double ?? 0
                                    APIServices.fetchInstance.getCryptoCurrencyApis(from: result.tradingPairsName, to: [priceType]) { (success, response) in
                                        if success{
                                            for result in response{
                                                currency = (result.1.double) ?? 0
                                            }
                                            let tran = Transactions()
                                            tran.coinAbbName = result.coinAbbName
                                            tran.transactionPrice = transactionPrice
                                            tran.defaultCurrencyPrice = singlePrice * currency
                                            tran.defaultTotalPrice = tran.defaultCurrencyPrice * amount
                                            tran.totalAmount = amount
                                            tran.totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                            tran.totalRiseFallPercent = (tran.totalRiseFallNumber / tran.transactionPrice) * 100
                                            
                                            
                                            
                                            floatingPrice =  ((singlePrice * currency) -  singleAverageBuyPrice) * totalAmount
                                            
                                            
                                            let object = try! Realm().objects(Transactions.self).filter("coinAbbName == %@",result.coinAbbName)
                                            
                                            try! Realm().write {
                                                if object.count != 0{
                                                    object[0].currentSinglePrice = singlePrice
                                                    object[0].currentTotalPrice = singlePrice * amount
                                                    object[0].currentNetValue = transactionPrice * (1/currency)
                                                    object[0].currentRiseFall = (singlePrice * amount) - (transactionPrice * (1/currency))
                                                    object[0].transactionPrice = transactionPrice
                                                    object[0].defaultCurrencyPrice = singlePrice * currency
                                                    object[0].defaultTotalPrice = (singlePrice * currency) * amount
                                                    object[0].totalAmount = amount
                                                    object[0].totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                                    object[0].totalRiseFallPercent =  tran.totalRiseFallPercent
                                                    object[0].floatingPrice = floatingPrice
                                                    object[0].unrealizedPrice = unrealizedPrice
                                                    object[0].floatingPercent = (floatingPrice / (singleAverageBuyPrice * totalAmount)) * 100
                                                }
                                            }
                                            completion(true)
                                        } else{
                                            completion(false)
                                        }
                                    }
                                }
                            }
                        } else{
                            completion(false)
                        }
                    } else{
                        completion(false)
                    }
                }
            } else{
                APIServices.fetchInstance.getExchangePriceData(from: result.coinAbbName, to: result.tradingPairsName, market: result.exchangeName) { (success, response) in
                    if success{
                        singlePrice = response["RAW"]["PRICE"].double ?? 0
                        APIServices.fetchInstance.getCryptoCurrencyApis(from: result.tradingPairsName, to: [priceType]) { (success, response) in
                            if success{
                                for result in response{
                                    currency = (result.1.double) ?? 0
                                }
                                let tran = Transactions()
                                tran.coinAbbName = result.coinAbbName
                                tran.transactionPrice = transactionPrice
                                tran.defaultCurrencyPrice = singlePrice * currency
                                tran.defaultTotalPrice = tran.defaultCurrencyPrice * amount
                                tran.totalAmount = amount
                                tran.totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                tran.totalRiseFallPercent = (tran.totalRiseFallNumber / tran.transactionPrice) * 100
                                floatingPrice =  ((singlePrice * currency) -  singleAverageBuyPrice) * totalAmount
                                
                                let object = try! Realm().objects(Transactions.self).filter("coinAbbName == %@",result.coinAbbName)
                                try! Realm().write {
                                    if object.count != 0{
                                        object[0].currentSinglePrice = singlePrice
                                        object[0].currentTotalPrice = singlePrice * amount
                                        object[0].currentNetValue = transactionPrice * (1/currency)
                                        object[0].currentRiseFall = (singlePrice * amount) - (transactionPrice * (1/currency))
                                        object[0].transactionPrice = transactionPrice
                                        object[0].defaultCurrencyPrice = singlePrice * currency
                                        object[0].defaultTotalPrice = (singlePrice * currency) * amount
                                        object[0].totalAmount = amount
                                        object[0].totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                        object[0].totalRiseFallPercent =  tran.totalRiseFallPercent
                                        object[0].floatingPrice = floatingPrice
                                        object[0].unrealizedPrice = unrealizedPrice
                                        object[0].floatingPercent = (floatingPrice / (singleAverageBuyPrice * totalAmount)) * 100
                                    }
                                }
                                completion(true)
                            } else{
                                completion(false)
                            }
                        }
                    } else{
                        completion(false)
                    }
                }
            }
        }
    }
    
}
