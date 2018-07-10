//
//  FavouriteCoinsRealm.swift
//  news app for blockchain
//
//  Created by Sheng Li on 10/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

class CoinsInWatchListRealm: Object {
    @objc dynamic var symbol = ""
    @objc dynamic var market = ""
    @objc dynamic var tradingPairsName = ""
    
    
    override class func primaryKey() -> String {
        return "symbol"
    }
}
