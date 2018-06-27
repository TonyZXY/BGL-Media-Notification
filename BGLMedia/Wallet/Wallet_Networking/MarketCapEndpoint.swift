//
//  MarketCapEndpoint.swift
//  apiWrapperTest
//
//  Created by yanshi on 26/4/18.
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

enum MarketCapPath: String{
    case ticker = "/v1/ticker/"
    case globalcap = "/v1/global/"
}

class MarketCapEndpoint: Endpoint{
    
    var type: MarketCapPath
    var coinId: String?
    
    init(type: MarketCapPath, coinId: String? = nil){
        self.type = type
        self.coinId = coinId
    }
    
    var base: String{
        return "https://api.coinmarketcap.com"
    }
    
    lazy var path = { () -> String in
        if(self.type == .ticker && coinId != nil){
            return self.type.rawValue + coinId! + "/"
        }else{
            return self.type.rawValue
        }
    }()
    
    var query = ""
    
    
}
