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

struct Currency:Decodable{
    var query:[String:Int]
    var results:[String:CurrencyPairs]
}

struct CurrencyPairs:Decodable{
    var id:String?
    var fr:String?
    var to:String?
    var val:Double?
}

struct GlobalCoinList:Decodable{
    var id:Int?
    var name:String?
    var symbol:String?
    var website_slug:String?
}

struct MetaData:Decodable{
    var timestamp:Int?
    var num_cryptocurrencies:Int?
    var error:String?
}

struct MarketCapData:Decodable {
    var data:[GlobalCoinList]?
    var metadata:MetaData?
}

class APIServices:NSObject{
    
    typealias tradingCoin = [String]
    typealias chooseCoin = [String:tradingCoin]
    typealias exchangeChoose = [String:chooseCoin]
    
    static let fetchInstance = APIServices()
//    let realm = try! Realm()
    let cryptoCompare = "https://min-api.cryptocompare.com/data/"
    let marketCap = "https://api.coinmarketcap.com/v2/"
    let itunes = "http://itunes.apple.com/lookup?bundleId="
    
    func writeJsonExchange(completion:@escaping (Bool)-> Void){
        Alamofire.request("https://min-api.cryptocompare.com/data/all/exchanges", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent("Exchanges.json")
                let json = JSON(value)
                do {
                    let rawData = try json.rawData()
                    try rawData.write(to: fileURL, options: .atomic)
                } catch {
                    print("Error \(error)")
                }
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func getExchangeList()->exchangeChoose{
        var jsonData = exchangeChoose()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("Exchanges.json").path
        if FileManager.default.fileExists(atPath: filePath), let data = FileManager.default.contents(atPath: filePath) {
            do{
                let json = try JSONDecoder().decode(exchangeChoose.self, from: data)
                jsonData = json as exchangeChoose
            } catch let jsonErr{
                print("Error serializing json:",jsonErr)
            }
        }
        return jsonData
    }
    
    func getTradingCoinList(market:String,coin:String)->tradingCoin{
        var jsonData = tradingCoin()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("Exchanges.json").path
        if FileManager.default.fileExists(atPath: filePath), let data = FileManager.default.contents(atPath: filePath) {
            do{
                let json = try JSONDecoder().decode(exchangeChoose.self, from: data)
                let coinTradingPairs = json[market]?[coin]
                if coinTradingPairs != nil{
                    jsonData = coinTradingPairs!
                }
            } catch let jsonErr{
                print("Error serializing json:",jsonErr)
            }
        }
        return jsonData
    }
    
    
    //Get Global Average Market Cap Value
    func getGlobalMarketData(completion:@escaping (Bool)-> Void){
        let realm = try! Realm()
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
                let specificData = res["data"]
//                print(specificData["quotes"][priceType]["total_market_cap"].double)
                realm.beginWrite()
                let marketCap = String(((specificData["quotes"][priceType]["total_market_cap"].double ?? 0)! / 10000000.0).rounded() / 100.0)
                let volume24 = String(((specificData["quotes"][priceType]["total_volume_24h"].double ?? 0)! / 10000000.0).rounded() / 100.0)
                let btcDominance = String(specificData["bitcoin_percentage_of_market_cap"].double?.rounded() ?? 0)
                let realmData:[Any] = [btcDominance,marketCap,volume24,"0"]

                if realm.object(ofType: GlobalMarketValueRealm.self, forPrimaryKey: "0") == nil {
                    realm.create(GlobalMarketValueRealm.self, value: realmData)
                } else {
                    realm.create(GlobalMarketValueRealm.self, value: realmData, update: true)
                }
                try! realm.commitWrite()
                
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func getExchangePriceData(from:String,to:String,market:String, completion:@escaping (Bool,JSON)-> Void){
        let baseUrl = cryptoCompare + "generateAvg?"
        let fsym = from
        let tsym = to
        let e = market
        let converUrl = baseUrl + "fsym=" + fsym + "&tsym=" + tsym + "&e=" + e
        print(converUrl)
        let url = URL(string: converUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    typealias StringCompletion = (_ success: Bool, _ jsonResult: [String:Double]) -> Void

    //Get currency rate and transfer the coin trading price to specific price type
    func getCryptoCurrencyApi(from:String,to:[String],price:Double,completion: @escaping StringCompletion){
        let baseUrl = "https://min-api.cryptocompare.com/data/price?"
        var currencyPairs = "fsym=" + from + "&" + "tsyms="
        for value in to{
            currencyPairs = currencyPairs + value + ","
        }
        let urlString = baseUrl + currencyPairs

        let queue = DispatchQueue(label: "currency rate")

        queue.sync {
            guard let url = URL(string: urlString) else { return completion(false,["":0])}
            let transferPrices = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return completion(false,["":0])}
                do{
                    let json = try JSONDecoder().decode([String:Double].self, from: data)
                    completion(true,json)
                } catch let jsonErr{
                    print("Error serializing json:",jsonErr)
                    completion(false,["":0])
                }
            }
            transferPrices.resume()
        }
    }
    
    func getCryptoCurrencyApis(from:String,to:[String],completion: @escaping (Bool,JSON)->Void){
        let baseUrl = "https://min-api.cryptocompare.com/data/price?"
        var currencyPairs = "fsym=" + from + "&" + "tsyms="
        for value in to{
            currencyPairs = currencyPairs + value + ","
        }
        let urlString = baseUrl + currencyPairs
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    func getMarketCapOneCoinData(coinId:Int, completion:@escaping (Bool,JSON)->Void){
        let realm = try! Realm()
        let urlString = marketCap + "ticker/" + String(coinId) + "/?convert=" + priceType
        
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                let result = response["data"]
                let symbol = result["symbol"].string ?? ""
                let coinId = result["id"].int ?? 0
                let coinName = result["name"].string ?? ""
                let totalSupply = result["total_supply"].double ?? 0
                let circulatingSupply = result["circulating_supply"].double ?? 0
                let currency = priceType
                let percent24h = result["quotes"][priceType]["percent_change_24h"].double ?? 0
                let percent1h = result["quotes"][priceType]["percent_change_1h"].double ?? 0
                let percent7d = result["quotes"][priceType]["percent_change_7d"].double ?? 0
                let volume24 = result["quotes"][priceType]["volume_24h"].double ?? 0
                let marketCap = result["quotes"][priceType]["market_cap"].double ?? 0
                let price = result["quotes"][priceType]["price"].double ?? 0
                let max_supply = result["max_supply"].double ?? 0
                let rank = result["rank"].int ?? 0
                let realmData:[Any] = ["0",coinId,symbol,coinName,totalSupply,circulatingSupply,currency,percent24h,percent1h,percent7d,volume24,max_supply,marketCap,price,rank]
                realm.beginWrite()
                if realm.object(ofType: GlobalAverageObject.self, forPrimaryKey: symbol) == nil {
                    realm.create(GlobalAverageObject.self, value: realmData)
                } else {
                    realm.create(GlobalAverageObject.self, value: realmData, update: true)
                }
                try! realm.commitWrite()
                
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    
    
    
    func getMarketCapOneCoinWatchListData(coinId:Int, completion:@escaping (Bool,JSON)->Void){
        let urlString = marketCap + "ticker/" + String(coinId) + "/?convert=" + priceType
        
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    func getRiseFallWeek(from:String,to:String,market:String,limit:Int,completion:@escaping (Bool,JSON)->Void){
        let urlString = cryptoCompare + "histoday?" + "fsym=" + from + "&tsym=" + to + "&e=" + market + "&limit=" + String(limit)
        print(urlString)
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    func getRiseFallDay(from:String,to:String,market:String,limit:Int,completion:@escaping (Bool,JSON)->Void){
        let urlString = cryptoCompare + "histohour?" + "fsym=" + from + "&tsym=" + to + "&e=" + market + "&limit=" + String(limit)
        print(urlString)
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    func getRiseFallHour(from:String,to:String,market:String,limit:Int,completion:@escaping (Bool,JSON)->Void){
        let urlString = cryptoCompare + "histohour?" + "fsym=" + from + "&tsym=" + to + "&e=" + market + "&limit=" + String(limit)
        print(urlString)
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    func getRiseFallMin(from:String,to:String,market:String,limit:Int,completion:@escaping (Bool,JSON)->Void){
        let urlString = cryptoCompare + "histominute?" + "fsym=" + from + "&tsym=" + to + "&e=" + market + "&limit=" + String(limit)
        let url = URL(string: urlString)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let response = JSON(value)
                completion(true,response)
            case .failure(let error):
                print(error)
                completion(false,JSON())
            }
        }
    }
    
    func getRiseFallPeriod(period:String,from:String,to:String,market:String,completion:@escaping (Bool,JSON)->Void){
        var exactMarket = market
        if exactMarket == "Global Average"{
            exactMarket = "CCCAGG"
        }
        
        let urlParam:[String:[String]] = ["Minute":["histominute?","29"],"Hour":["histohour?","3"],"Day":["histohour?","23"],"Week":["histoday?","5"]]
        if period == "Minute" || period == "Hour" || period == "Day" || period == "Week"{
            let urlString = cryptoCompare + ((urlParam[period]) ?? ["histominute?","29"])[0] + "fsym=" + from + "&tsym=" + to + "&e=" + exactMarket + "&limit=" + ((urlParam[period]) ?? ["histominute?","29"])[1]
            let url = URL(string: urlString)
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "GET"
            
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            Alamofire.request(urlRequest).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let response = JSON(value)
                    completion(true,response)
                case .failure(let error):
                    print(error)
                    completion(false,JSON())
                }
            }
        } else{
            completion(false,JSON())
        }
    }
    
    func getLatestVersion(completion:@escaping (JSON,Bool)->Void){
        let url = URL(string: itunes + "com.blockchainglobal.bglmedia")
        var urlRequest = URLRequest(url: url!)
        //        URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10
        Alamofire.request(urlRequest).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let res = JSON(value)
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
}
