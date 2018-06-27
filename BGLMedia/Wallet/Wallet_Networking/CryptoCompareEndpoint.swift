//
//  CryptoComparePath.swift
//  ApiWrapperTest
//
//  Created by yanshi on 23/4/18.
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

enum CryptoComparePath: String{
    case coinlist = "/data/all/coinlist"
    case exchanges = "/data/all/exchanges"
    case price = "/data/price"
    case proceMulti = "/data/pricemulti"
}

class CryptoCompareEndpoint: Endpoint{
    
    var type: CryptoComparePath
    
    init(type:CryptoComparePath){
        self.type = type
    }
        
    var query: String = ""
    
    
    var base: String{
        return "https://min-api.cryptocompare.com"
    }
    
    lazy var path = {
        return self.type.rawValue
    }()
}
