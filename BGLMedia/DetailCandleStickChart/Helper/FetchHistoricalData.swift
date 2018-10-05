//
//  FetchData.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 18/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
typealias CompletionHandler = (() -> Void)?

class HistoricalDataFetcher {
    var historicalDataStruct: HistoricalDataStruct?
    var selectDate = ["histominute":"1min", "histohour":"60min", "histoday":"1day"]
    static var dataTask: URLSessionDataTask?
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    var limit: Int {
        return Params.amountOfCandlesDisplayed * Params.interval * Params.multipleData
    }
    
    // intervel should be:
    // histoday, histohour, histominute
    func fetcher(coinSymbol: String, currency: String = priceType, completionHandler: CompletionHandler = nil) {
        let url = URL(string: "https://min-api.cryptocompare.com/data/\(Params.intervalParam)?fsym=\(coinSymbol)&tsym=\(currency)&limit=\(limit)")
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let urlRequest = URLRequest(url: url!)
            HistoricalDataFetcher.dataTask = self.defaultSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let _ = error {
                    return
                } else {
                    DispatchQueue.main.async {
                        self.historicalDataStruct = HistoricalDataStruct(json: data)
                        completionHandler?()
                    }
                }
            })
            HistoricalDataFetcher.dataTask?.resume()
        }
    }
    
    func fetcher(coinSymbol: String, currency: String, exchangeName:String, completionHandler: CompletionHandler = nil) {
        let urlString:String? = "https://min-api.cryptocompare.com/data/\(Params.intervalParam)?fsym=\(coinSymbol)&tsym=\(currency)&e=\(exchangeName.replacingOccurrences(of: " ", with: ""))&limit=\(limit)"
        guard let urlStrings = urlString, let url = URL(string: urlStrings)else{return (completionHandler?())! }
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let urlRequest = URLRequest(url: url)
            HistoricalDataFetcher.dataTask = self.defaultSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let _ = error {
                    return
                } else {
                    DispatchQueue.main.async {
                        self.historicalDataStruct = HistoricalDataStruct(json: data)
                        completionHandler?()
                    }
                }
            })
            HistoricalDataFetcher.dataTask?.resume()
        }
    }
    
    func fetcherHuobi(coinSymbol: String, currency: String, exchangeName:String, completionHandler: CompletionHandler = nil) {
        
        let urlString:String? = "https://api.huobi.com.au/market/history/kline?period=\(((selectDate[Params.intervalParam]) ?? "30min"))&size=\(limit)&symbol=\(coinSymbol.lowercased()+currency.lowercased())"
        guard let urlStrings = urlString, let url = URL(string: urlStrings)else{return (completionHandler?())! }
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let urlRequest = URLRequest(url: url)
            HistoricalDataFetcher.dataTask = self.defaultSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let _ = error {
                    return
                } else {
                    DispatchQueue.main.async {
                        self.historicalDataStruct = HistoricalDataStruct(json: data)
                        completionHandler?()
                    }
                }
            })
            HistoricalDataFetcher.dataTask?.resume()
        }
    }
}
