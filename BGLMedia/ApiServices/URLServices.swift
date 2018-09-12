//
//  URLServices.swift
//  BGLMedia
//
//  Created by Bruce Feng on 10/7/18.
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

class URLServices:NSObject{
    
    var email:String{
        get{
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
        }
    }
    
    var certificateToken:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
        }
    }
    
    var assets: Results<EachTransactions>{
        get{
            return try! Realm().objects(EachTransactions.self).sorted(byKeyPath: "id")
        }
    }
    
    
    
    static let fetchInstance = URLServices()
    let realm = try! Realm()
//    "https://bglnewsbkend.tk"
    func passServerData(urlParameters:[String],httpMethod:String,parameters:[String:Any],completion:@escaping (JSON, Bool)->Void){
        var BaseURl = "https://cryptogeekapp.com"
//        "https://bglnewsbkend.tk"
        for path in urlParameters{
            BaseURl = BaseURl + "/" + path
        }
        let url = URL(string: BaseURl)
        var urlRequest = URLRequest(url: url!)
//        URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        urlRequest.httpMethod = httpMethod
        
        if httpMethod == "POST"{
            let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = httpBody
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.timeoutInterval = 10
        
        
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 20
//        manager.session.configuration.timeoutIntervalForResource = 20
        
        
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 10
//        configuration.timeoutIntervalForResource = 10
//        let sessionManager = Alamofire.SessionManager(configuration: configuration)
//        let sessionManager = Alamofire.Manager.sharedInstance
        
        
        
        Alamofire.request(urlRequest).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let res = JSON(value)
//                print("get success")
//                print(res)
                
                completion(res,true)
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    completion(JSON(),false)
                } else{
                    print(error)
                    print("get faliure")
                    completion(JSON(),false)
                }
            }
        }
    }
    
    //Get coin List
    func getCoinList(completion:@escaping (Bool)-> Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoinList"], httpMethod: "Get", parameters: [String:Any]()) { (response, success) in
            if success{
                self.realm.beginWrite()
                for result in response.array!{
                    let id = result["_id"].string ?? ""
                    let coinName = result["coinName"].string?.trimmingCharacters(in: NSCharacterSet.whitespaces) ?? ""
                    let coinSymbol = result["coinSymbol"].string?.trimmingCharacters(in: NSCharacterSet.whitespaces) ?? ""
                    var logoURL:String = ""
                    if let logoUrl = result["logoUrl"].string{
                        logoURL = logoUrl
                    }
                    if self.realm.object(ofType: CoinList.self, forPrimaryKey: coinSymbol) == nil {
                        self.realm.create(CoinList.self, value: [id, coinName, coinSymbol,logoURL])
                    } else {
                        self.realm.create(CoinList.self, value: [id, coinName, coinSymbol,logoURL], update: true)
                    }
                }
                try! self.realm.commitWrite()
                completion(true)
            } else{
                completion(false)
            }
        }
    }
    
    //Get Global Average Market Coin List
    func getGlobalAverageCoinList(completion:@escaping (Bool)->Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["coin","getAllWithCurrency?currency=" + priceType], httpMethod: "GET", parameters: [String:Any]()){
            response,pass in
            if pass{
                self.realm.beginWrite()
                let realmObject = self.realm.objects(GlobalAverageObject.self)
                for result in response.array!{
                    let coinAbbName = result["symbol"].string?.trimmingCharacters(in: NSCharacterSet.whitespaces) ?? ""
                    if self.realm.objects(CoinList.self).filter("coinSymbol = %@", coinAbbName).count != 0{
                        let id = result["_id"].string ?? ""
                        let coinId = result["id"].int ?? 0
                        let coinName = result["name"].string?.trimmingCharacters(in: NSCharacterSet.whitespaces) ?? ""
                        let totalSupply = result["total_supply"].double ?? 0
                        let circulatingSupply = result["circulating_supply"].double ?? 0
                        let currency = result["quotes"][0]["currency"].string ?? ""
                        let percent24h = result["quotes"][0]["data"]["percent_change_24h"].double ?? 0
                        let percent1h = result["quotes"][0]["data"]["percent_change_1h"].double ?? 0
                        let percent7d = result["quotes"][0]["data"]["percent_change_7d"].double ?? 0
                        let volume24 = result["quotes"][0]["data"]["volume_24h"].double ?? 0
                        let marketCap = result["quotes"][0]["data"]["market_cap"].double ?? 0
                        let price = result["quotes"][0]["data"]["price"].double ?? 0
                        let max_supply = result["max_supply"].double ?? 0
                        let rank = result["rank"].int ?? 0
                        let realmData:[Any] = [id,coinId,coinAbbName,coinName,totalSupply,circulatingSupply,currency,percent24h,percent1h,percent7d,volume24,max_supply,marketCap,price,rank]
                        if self.realm.object(ofType: GlobalAverageObject.self, forPrimaryKey: coinAbbName) == nil {
                            self.realm.create(GlobalAverageObject.self, value: realmData)
                        } else {
                            self.realm.create(GlobalAverageObject.self, value: realmData, update: true)
                        }
                    } else{
                        if realmObject.filter("coinAbbName = %@", coinAbbName).count != 0{
                            self.realm.delete(realmObject.filter(coinAbbName))
                        }
                    }
                }
                try! self.realm.commitWrite()
                completion(true)
            } else{
                completion(false)
            }
        }
    }
    
    
    func storeNotificationDataToRealm(completion:@escaping (Bool)->Void){
//        let email = UserDefaults.standard.string(forKey: "UserEmail")!
        let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken")!
        let body:[String:Any] = ["email":email,"token":certificateToken]
        
        
        URLServices.fetchInstance.passServerData(urlParameters:["userLogin","getInterest"],httpMethod:"POST",parameters:body){(response, pass) in
            if pass{
                if response["success"].bool!{
                    for result in response["data"].array!{
                        self.realm.beginWrite()
                        let id = result["_id"].int ?? 0
                        let coinName = result["from"].string ?? "null"
                        let coinAbbName = result["from"].string ?? "null"
                        let tradingPairs = result["to"].string ?? "null"
                        let exchangName = result["market"].string ?? "null"
                        let comparePice = result["price"].double ?? 0
                        let compareStatus = result["isgreater"].int ?? 0
                        let switchStatus = result["status"].bool ?? true
                        
                        
                        let realmData:[Any] = [id,coinName,coinAbbName,tradingPairs,exchangName,comparePice,compareStatus,switchStatus,Date()]
                        if self.realm.object(ofType: alertObject.self, forPrimaryKey: id) == nil {
                            self.realm.create(alertObject.self, value: realmData)
                        } else {
                            self.realm.create(alertObject.self, value: realmData, update: true)
                        }
                        
                        if self.realm.object(ofType: alertCoinNames.self, forPrimaryKey: coinAbbName) == nil {
                            self.realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!])
                        } else {
                            self.realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!], update: true)
                        }
                        try! self.realm.commitWrite()
                    }
                    completion(true)
                } else{
                    try! self.realm.write {
                        self.realm.delete(self.realm.objects(alertObject.self))
                    }
                    completion(false)
                }
            } else{
                try! self.realm.write {
                    self.realm.delete(self.realm.objects(alertObject.self))
                }
                completion(false)
            }
        }
    }
    
    

    func getAssets(completion:@escaping (Bool)->Void){
        let body:[String:Any] = ["email":email,"token":certificateToken]
        let realm = try! Realm()
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","getTransactions"], httpMethod: "POST", parameters: body) { (response, success) in
            if success{
                if let dataResult = response["data"].array{
                    try! realm.write{
                        realm.delete(realm.objects(Transactions.self))
                        realm.delete(realm.objects(EachTransactions.self))
                        realm.delete(realm.objects(EachCurrency.self))
                    }
                    
                    for result in dataResult{
                        let newTransactions = EachTransactions()
                        newTransactions.coinAbbName = result["coin_add_name"].string ?? ""
                        newTransactions.singlePrice = result["single_price"].double ?? 0
                        newTransactions.additional = result["note"].string ?? ""
                        newTransactions.coinName = result["coin_name"].string ?? ""
                        newTransactions.amount = result["amount"].double ?? 0
                        newTransactions.id = result["transaction_id"].int ?? 0
                        newTransactions.status = result["status"].string ?? ""
                        newTransactions.tradingPairsName = result["trading_pair_name"].string ?? ""
                        newTransactions.exchangeName = result["exchange_name"].string ?? ""
                        newTransactions.totalPrice = newTransactions.singlePrice * newTransactions.amount
                        //                   let transactionUserId = result["transaction_user_id"].int ?? 0
                        let currencyUSD = result["currency_usd"].double ?? 0
                        let currencyEUR = result["currency_eur"].double ?? 0
                        let currencyCNY = result["currency_cny"].double ?? 0
                        let currencyAUD = result["currency_aud"].double ?? 0
                        let currencyJPY = result["currency_jpy"].double ?? 0
                        let Longdate = result["date"].string ?? ""
                        newTransactions.date = Extension.method.convertStringToDate3(date:Longdate)
                        newTransactions.time = Extension.method.convertStringToDate4(date:Longdate)
                        let allCurrencys = List<EachCurrency>()
                        let ac:[String:Double] = ["USD":currencyUSD,"AUD":currencyAUD,"CNY":currencyCNY,"EUR":currencyEUR,"JPY":currencyJPY]
                        for results in ac{
                            let currencys = EachCurrency()
                            currencys.name = results.key
                            currencys.price = results.value
                            allCurrencys.append(currencys)
                        }
                        newTransactions.currency = allCurrencys
                        let tran = Transactions()
                        tran.coinAbbName = newTransactions.coinAbbName
                        tran.coinName = newTransactions.coinName
                        tran.exchangeName = "Global Average"
                        tran.tradingPairsName = priceType
           
                        realm.beginWrite()
                        if realm.object(ofType: Transactions.self, forPrimaryKey: newTransactions.coinAbbName) == nil {
                            tran.everyTransactions.append(newTransactions)
                            realm.add(tran, update: true)
                            
                        } else{
                            let object = realm.objects(Transactions.self).filter("coinAbbName == %@", newTransactions.coinAbbName)
                            if object.count != 0{
                                let newT = realm.create(EachTransactions.self, value: newTransactions, update: true)
                                object[0].everyTransactions.append(newT)
//                                realm.add(newTransactions, update: true)
//                                object[0].everyTransactions.append(newTransactions)
                            }
                        }
                        try! realm.commitWrite()
                    }
                    completion(true)
                }
                completion(false)
            } else{
                completion(false)
            }
        }
    }
    
    func getSpecificAssets(coinAbbName:String, completion:@escaping (Bool)->Void){
        let body:[String:Any] = ["email":email,"token":certificateToken]
        let realm = try! Realm()
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","getTransactions"], httpMethod: "POST", parameters: body) { (response, success) in
            if success{
                let coinObject = realm.objects(Transactions.self).filter("coinAbbName = %@",coinAbbName)
                if coinObject.count > 0{
                    if let dataResult = response["data"].array{
                        try! realm.write{
                            realm.delete(coinObject[0])
//                            realm.delete(coinObject[0].everyTransactions)
                        }
                        
                        for result in dataResult{
                            if let coinNameResult = result["coin_add_name"].string{
                                if coinNameResult == coinAbbName{
                                    let newTransactions = EachTransactions()
                                    newTransactions.coinAbbName = result["coin_add_name"].string ?? ""
                                    newTransactions.singlePrice = result["single_price"].double ?? 0
                                    newTransactions.additional = result["note"].string ?? ""
                                    newTransactions.coinName = result["coin_name"].string ?? ""
                                    newTransactions.amount = result["amount"].double ?? 0
                                    newTransactions.id = result["transaction_id"].int ?? 0
                                    newTransactions.status = result["status"].string ?? ""
                                    newTransactions.tradingPairsName = result["trading_pair_name"].string ?? ""
                                    newTransactions.exchangeName = result["exchange_name"].string ?? ""
                                    newTransactions.totalPrice = newTransactions.singlePrice * newTransactions.amount
                                    let currencyUSD = result["currency_usd"].double ?? 0
                                    let currencyEUR = result["currency_eur"].double ?? 0
                                    let currencyCNY = result["currency_cny"].double ?? 0
                                    let currencyAUD = result["currency_aud"].double ?? 0
                                    let currencyJPY = result["currency_jpy"].double ?? 0
                                    let Longdate = result["date"].string ?? ""
                                    newTransactions.date = Extension.method.convertStringToDate3(date:Longdate)
                                    newTransactions.time = Extension.method.convertStringToDate4(date:Longdate)
                                    let allCurrencys = List<EachCurrency>()
                                    let ac:[String:Double] = ["USD":currencyUSD,"AUD":currencyAUD,"CNY":currencyCNY,"EUR":currencyEUR,"JPY":currencyJPY]
                                    for results in ac{
                                        let currencys = EachCurrency()
                                        currencys.name = results.key
                                        currencys.price = results.value
                                        allCurrencys.append(currencys)
                                    }
                                    newTransactions.currency = allCurrencys
                                    let tran = Transactions()
                                    tran.coinAbbName = newTransactions.coinAbbName
                                    tran.coinName = newTransactions.coinName
                                    tran.exchangeName = "Global Average"
                                    tran.tradingPairsName = priceType
                                    
                                    realm.beginWrite()
                                    if realm.object(ofType: Transactions.self, forPrimaryKey: newTransactions.coinAbbName) == nil {
                                        tran.everyTransactions.append(newTransactions)
                                        realm.add(tran, update: true)
                                    } else{
                                        let object = realm.objects(Transactions.self).filter("coinAbbName == %@", newTransactions.coinAbbName)
                                        if object.count != 0{
                                            let newT = realm.create(EachTransactions.self, value: newTransactions, update: true)
                                            object[0].everyTransactions.append(newT)
                                        }
                                    }
                                    try! realm.commitWrite()
                                }
                            }
                        }
                        completion(true)
                    }
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
    }
    
    
    func sendAssets(completion:@escaping (Bool)->Void){
        var allTransaction = [[String:Any]]()
        for newTransaction in assets{
            let newDate = newTransaction.date + " " + newTransaction.time
            let transactions:[String:Any] = [
                "status":newTransaction.status,
                "coinName":newTransaction.coinName,
                "coinAddName":newTransaction.coinAbbName,
                "exchangeName":newTransaction.exchangeName,
                "tradingPairName":newTransaction.tradingPairsName,
                "singlePrice":newTransaction.singlePrice,
                "amount":newTransaction.amount,
                "currencyAUD": (newTransaction.currency.filter{name in return name.name.contains("AUD")}.first?.price) ?? 0,
                "currencyUSD": (newTransaction.currency.filter{name in return name.name.contains("USD")}.first?.price) ?? 0,
                "currencyJPY": (newTransaction.currency.filter{name in return name.name.contains("JPY")}.first?.price) ?? 0,
                "currencyEUR": (newTransaction.currency.filter{name in return name.name.contains("EUR")}.first?.price) ?? 0,
                "currencyCNY": (newTransaction.currency.filter{name in return name.name.contains("CNY")}.first?.price) ?? 0,
                "date":Extension.method.convertStringToDate2(date: newDate),
                "note":newTransaction.additional,
                ]
            allTransaction.append(transactions)
        }
        
        if allTransaction.count != 0{
            let body:[String:Any] = ["email":self.email,"token":self.certificateToken,"transactions":allTransaction]
            URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","addTransaction"], httpMethod: "POST", parameters: body) { (response, success) in
                if success{
                    completion(true)
                }else{
                    completion(false)
                }
            }
        } else{
            completion(false)
        }
    }
}
