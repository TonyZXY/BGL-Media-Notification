//
//  CoinList.swift
//  ApiWrapperTest
//
//  Created by yanshi on 23/4/18.
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

struct  CryptoCompareCoinListResult: Decodable {
    let Data: [String:CryptoCompareCoin]
    
    init?(json: Data?) // take some JSON and try to init an EmojiArt from it
    {
        if let data = json, let newValue = try? JSONDecoder().decode(CryptoCompareCoinListResult.self, from: data) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(data: [String:CryptoCompareCoin]) {
        self.Data = data
    }
}
