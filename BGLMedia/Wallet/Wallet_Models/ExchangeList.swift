//
//  ExchangeList.swift
//  apiWrapperTest
//
//  Created by yanshi on 24/4/18.
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

struct ExchangeList:Decodable{
    var AllExchanges: [String: Exchange]
    
    init(){
        self.AllExchanges = [String: Exchange]()
    }
}
