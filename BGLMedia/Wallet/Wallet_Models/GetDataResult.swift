//
//  GetDataResult.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 8/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

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

class GetDataResult{
    let cryptoCompareClient = CryptoCompareClient()
    let container = try! Container()
    typealias tradingCoin = [String]
    typealias chooseCoin = [String:tradingCoin]
    typealias exchangeChoose = [String:chooseCoin]
    
    //Get coins details from CryptoCompare api and save to the realm
    func getCoinList(){
        cryptoCompareClient.getCoinList(){result in
            switch result{
            case .success(let resultData):
                guard let coinList = resultData?.Data else {return}
                for (_,value) in coinList{
                    try! self.container.write { transaction in
                        transaction.add(value, update: true)
                    }
                }
            case .failure(let error):
                print("the error \(error.localizedDescription)")
            }
        }
    }
    
    //Get exchange market detail from local json file (Cryptocurrency Api)
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
    
    //Get the coin list details from local json file (Market Cap Api)
    func getMarketCapCoinList()->[GlobalCoinList]{
        var jsonData = [GlobalCoinList]()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("CoinList.json").path
        if FileManager.default.fileExists(atPath: filePath), let data = FileManager.default.contents(atPath: filePath) {
            do{
                let json = try JSONDecoder().decode(MarketCapData.self, from: data)
                jsonData = (json.data)!
            } catch let jsonErr{
                print("Error serializing json:",jsonErr)
            }
        }
        return jsonData
    }
    
    //Get specific coins global detail data using market cap api (for example: Market Cap, Volume24h, Supply)
    func getMarketCapCoinDetail(coinId:Int,priceType:String,completion:@escaping (GlobalMarket?,Bool)->Void){
        let baseUrl:String = "https://api.coinmarketcap.com/v2/ticker/"
        let urlString:String = baseUrl + String(coinId) + "/?convert=" + priceType
        Alamofire.request(urlString).responseJSON { (response) in
            let json = try! JSONDecoder().decode(MarketAllData.self, from: response.data!)
            if json.data != nil{
                let globalMarket:GlobalMarket = GlobalMarket(market: json, priceType: priceType)
                completion(globalMarket,true)
            } else{
                completion(nil,false)
            }
        }
    }
    
    //Get trading pairs Name base on specific market name and coin name
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
}


