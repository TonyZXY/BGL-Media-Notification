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

class URLServices:NSObject{
    static let fetchInstance = URLServices()
    let realm = try! Realm()
    func passServerData(urlParameters:[String],httpMethod:String,parameters:[String:Any],completion:@escaping (JSON, Bool)->Void){
        var BaseURl = "http://10.10.6.18:3020"
        for path in urlParameters{
            BaseURl = BaseURl + "/" + path
        }
        let url = URL(string: BaseURl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = httpMethod
        
        if httpMethod == "POST"{
            let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = httpBody
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let res = JSON(value)
                print("get success")
//                print(res)
                completion(res,true)
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    completion(JSON(),false)
                }
                print(error)
                print("get faliure")
                completion(JSON(),false)
            }
        }
    }
    
    //Get coin List
    func getCoinList(){
        URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoinList"], httpMethod: "Get", parameters: [String:Any]()) { (json, success) in
            if success{
                
                self.realm.beginWrite()
                for result in json.array!{
                    let id = result["_id"].string!
                    let coinName = result["coinName"].string!
                    let coinSymbol = result["coinSymbol"].string!
                    var logoURL:String = ""
                    if let logoUrl = result["logoUrl"].string{
                        logoURL = logoUrl
                    }
                  
                    if self.realm.object(ofType: CoinList.self, forPrimaryKey: id) == nil {
                        self.realm.create(CoinList.self, value: [id, coinName, coinSymbol,logoURL])
                    } else {
                        self.realm.create(CoinList.self, value: [id, coinName, coinSymbol,logoURL], update: true)
                    }
                }
                try! self.realm.commitWrite()
            }
        }
    }
    
    //Get Global Average Market Coin List
    func getGlobalAverageCoinList(completion:@escaping (Bool)->Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["coin","getAllWithCurrency?currency=" + priceType], httpMethod: "GET", parameters: [String:Any]()){
            response,pass in
            if pass{
                self.realm.beginWrite()
                for result in response.array!{
                    let id = result["_id"].string ?? ""
                    let coinAbbName = result["symbol"].string ?? ""
                    let coinName = result["name"].string ?? ""
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
                    let realmData:[Any] = [id,coinAbbName,coinName,totalSupply,circulatingSupply,currency,percent24h,percent1h,percent7d,volume24,max_supply,marketCap,price]
                    if self.realm.object(ofType: GlobalAverageObject.self, forPrimaryKey: id) == nil {
                        self.realm.create(GlobalAverageObject.self, value: realmData)
                    } else {
                        self.realm.create(GlobalAverageObject.self, value: realmData, update: true)
                    }
                }
                try! self.realm.commitWrite()
                completion(true)
            } else{
                completion(false)
            }
        }
    }
    
    
    
    
}
