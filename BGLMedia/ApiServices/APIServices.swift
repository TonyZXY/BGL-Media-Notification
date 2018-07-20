//
//  APIServices.swift
//  BGLMedia
//
//  Created by Bruce Feng on 12/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Realm
import SwiftyJSON
import Alamofire
import RealmSwift

class APIServices:NSObject{
    static let fetchInstance = APIServices()
    let realm = try! Realm()
    let cryptoCompare = "https://min-api.cryptocompare.com/data/"
    let marketCap = "https://api.coinmarketcap.com/v2/"
    
    
    
    //Get Global Average Market Cap Value
    func getGlobalMarketData(completion:@escaping (Bool)-> Void){
        let baseUrl = marketCap + "global/"
        let converUrl = baseUrl + "?convert=" + priceType
        
        let url = URL(string: converUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let res = JSON(value)
                print(res)
                let specificData = res["data"]
//                print(specificData["quotes"][priceType]["total_market_cap"].double)
                self.realm.beginWrite()
                let marketCap = String(((specificData["quotes"][priceType]["total_market_cap"].double ?? 0)! / 10000000.0).rounded() / 100.0)
                let volume24 = String(((specificData["quotes"][priceType]["total_volume_24h"].double ?? 0)! / 10000000.0).rounded() / 100.0)
                let btcDominance = String(specificData["bitcoin_percentage_of_market_cap"].double?.rounded() ?? 0)
                let realmData:[Any] = [btcDominance,marketCap,volume24,"0"]

                if self.realm.object(ofType: GlobalMarketValueRealm.self, forPrimaryKey: "0") == nil {
                    self.realm.create(GlobalMarketValueRealm.self, value: realmData)
                } else {
                    self.realm.create(GlobalMarketValueRealm.self, value: realmData, update: true)
                }
                try! self.realm.commitWrite()
                
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func getExchangePriceData(from:String,to:String,market:String, completion:@escaping (JSON,Bool)-> Void){
        let baseUrl = cryptoCompare + "generateAvg?"
        let fsym = from
        let tsym = to
        let e = market
        let converUrl = baseUrl + "fsym=" + fsym + "&tsym=" + tsym + "&e=" + e
        let url = URL(string: converUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                print(response)
//                let res = JSON(value)
//                print(res)
//                let specificData = res["data"]
//                //                print(specificData["quotes"][priceType]["total_market_cap"].double)
//                self.realm.beginWrite()
//                let marketCap = String(((specificData["quotes"][priceType]["total_market_cap"].double ?? 0)! / 10000000.0).rounded() / 100.0)
//                let volume24 = String(((specificData["quotes"][priceType]["total_volume_24h"].double ?? 0)! / 10000000.0).rounded() / 100.0)
//                let btcDominance = String(specificData["bitcoin_percentage_of_market_cap"].double?.rounded() ?? 0)
//                let realmData:[Any] = [btcDominance,marketCap,volume24,"0"]
//
//                if self.realm.object(ofType: GlobalMarketValueRealm.self, forPrimaryKey: "0") == nil {
//                    self.realm.create(GlobalMarketValueRealm.self, value: realmData)
//                } else {
//                    self.realm.create(GlobalMarketValueRealm.self, value: realmData, update: true)
//                }
//                try! self.realm.commitWrite()
                
                completion(response,true)
            case .failure(let error):
                print(error)
                completion(JSON(),false)
            }
        }
        
    }
    
}
