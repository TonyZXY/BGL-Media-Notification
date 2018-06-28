//
//  MarketCapClient.swift
//  apiWrapperTest
//
//  Created by yanshi on 26/4/18.
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

class MarketCapClient: APIClient{
    var session: URLSession
    var defaultCurrency: String
    
    typealias CoinDetails = [String: String?]
    typealias CoinCapList = [CoinDetails]
    typealias GlobalCap = [String: Double?]
    
    init(configuration: URLSessionConfiguration, currency: String? = priceType){
        self.session = URLSession(configuration: configuration)
        self.defaultCurrency = currency!
    }
    
    convenience init(){
        self.init(configuration: .default)
    }
    
    func getTickers(limit:Int=10, convert:String?=nil, completion: @escaping (Result<CoinCapList?, APIError>)->Void){
        let queryStr = ["limit="+String(limit), "convert=" + (convert ?? self.defaultCurrency)].joined(separator: "&")
        let endpoint = MarketCapEndpoint(type: MarketCapPath.ticker)
        endpoint.query = queryStr
        let request = endpoint.request

        fetch(with: request, decode: { json -> CoinCapList? in
            guard let coinCapList = json as? CoinCapList else {return nil}
            return coinCapList
        }, completion: completion)

    }
    
    func getTrickerById(coinId:String, convert:String?=nil, completion: @escaping (Result<CoinCapList?, APIError>)->Void){
        let queryStr = "convert=" + (convert ?? self.defaultCurrency)
        let endpoint = MarketCapEndpoint(type: MarketCapPath.ticker)
        endpoint.coinId = coinId
        endpoint.query = queryStr
        
        let request = endpoint.request
        
        fetch(with: request, decode: { json -> CoinCapList? in
            guard let coinCapDetail = json as? CoinCapList else {return nil}
            return coinCapDetail
        }, completion: completion)
    }
    
    func getGlobalCap(convert:String?=nil, completion: @escaping (Result<GlobalCap?, APIError>)->Void){
        let queryStr = "convert=" + (convert ?? self.defaultCurrency)
        let endpoint = MarketCapEndpoint(type: MarketCapPath.globalcap)
        endpoint.query = queryStr
        
        let request = endpoint.request
        fetch(with: request, decode: { json -> GlobalCap? in
            guard let globalCap = json as? GlobalCap else {return nil}
            return globalCap
        }, completion: completion)
        
    }
}
