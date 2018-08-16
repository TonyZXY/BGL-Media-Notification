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
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.session.configuration.timeoutIntervalForResource = 20
        
        
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 10
//        configuration.timeoutIntervalForResource = 10
//        let sessionManager = Alamofire.SessionManager(configuration: configuration)
//        let sessionManager = Alamofire.Manager.sharedInstance
        
        
        
        manager.request(urlRequest).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let res = JSON(value)
                print("get success")
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
                print(response)
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
                            print(coinAbbName)
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

    
    
}
