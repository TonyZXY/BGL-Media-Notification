//
//  TickerDataFetcherV2.swift
//  news app for blockchain
//
//  Created by Sheng Li on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class TickerDataFetcherV2 {
    static var starts = 1
    static var num_cryptocurrencies = 1623
    static var isFetching = false
    
    func fetchTickerDataWrapper() {
        if !TickerDataFetcherV2.isFetching {
            TickerDataFetcherV2.isFetching = true
            getCoinList() {
                self.getAllTickerData()
            }
        }
    }
    
    func getTickerData(completionHandler: CompletionHandler = nil) {
        let url = "https://api.coinmarketcap.com/v2/ticker/?convert=\(priceType)&start=\(String(describing: TickerDataFetcherV2.starts))"
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: URL(string: url)!) else {
                // fetching failed
                TickerDataFetcherV2.isFetching = false
                TickerDataFetcherV2.starts = Int.max
                DispatchQueue.main.async {
                    completionHandler?()
                }
                return
            }
            let json = JSON(data)
            self.JSONtoData(json: json)
            DispatchQueue.main.async {
                completionHandler?()
            }
        }
    }
    
    func JSONtoData(json: JSON) {
        let realm = try! Realm()
        realm.beginWrite()
        if let collection = json["data"].dictionary {
            for item in collection.values {
                let quotes = item["quotes"][priceType]
                let symbol = item["symbol"].string ?? "--"
                let name = item["name"].string ?? "--"
                let price = quotes["price"].double ?? 0.0
                let percent_change_1h = quotes["percent_change_1h"].double ?? 0.0
                let percent_change_24h = quotes["percent_change_24h"].double ?? 0.0
                let percent_change_7d = quotes["percent_change_7d"].double ?? 0.0
                let volume_24h = quotes["volume_24h"].double ?? 0.0
                let market_cap = quotes["market_cap"].double ?? 0.0
                let circulating_supply = item["circulating_supply"].double ?? 0.0
                let quotesUSD = item["quotes"]["USD"]
                let usd_price = quotesUSD["price"].double ?? 0.0
                let usd_volume_24h = quotesUSD["volume_24h"].double ?? 0.0
                let usd_market_cap = quotesUSD["market_cap"].double ?? 0.0
                let data = [symbol, name, price, percent_change_1h, percent_change_24h, percent_change_7d, volume_24h, market_cap, circulating_supply, usd_price, usd_volume_24h, usd_market_cap] as [Any]
                if realm.object(ofType: TickerDataRealm.self, forPrimaryKey: symbol) == nil {
                    realm.create(TickerDataRealm.self, value: data)
                } else {
                    realm.create(TickerDataRealm.self, value: data, update: true)
                }
            }
        }
        try! realm.commitWrite()
        if let num_cryptocurrencies = json["data"]["num_cryptocurrencies"].int {
            TickerDataFetcherV2.num_cryptocurrencies = num_cryptocurrencies
        }
    }
    
    func getAllTickerData() {
        getTickerData() {
            if TickerDataFetcherV2.starts == Int.max || TickerDataFetcherV2.starts + 100 > TickerDataFetcherV2.num_cryptocurrencies{
                TickerDataFetcherV2.starts = 1
                TickerDataFetcherV2.isFetching = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeWatchInMarketsCell"), object: nil)
            } else {
                TickerDataFetcherV2.starts += 100
                self.getAllTickerData()
            }
        }
    }
    
    func getCoinList(completionHandler: CompletionHandler = nil) {
        let container = try! Container()
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: URL(string: "https://min-api.cryptocompare.com/data/all/coinlist")!) else { return }
            guard let coinList = CryptoCompareCoinListResult(json: data)?.Data else { return }
            DispatchQueue.main.async {
                for (_, value) in coinList {
                    try! container.write { transaction in
                        transaction.add(value, update: true)
                    }
                }
                completionHandler?()
            }
        }
    }
}
