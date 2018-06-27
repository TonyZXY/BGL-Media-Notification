//
//  Exchange.swift
//  apiWrapperTest
//
//  Created by yanshi on 24/4/18.
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

struct Exchange:Decodable {
    var TradingPairs: [String:[String]]
    
    init(){
        self.TradingPairs = [String:[String]]()
    }
}
