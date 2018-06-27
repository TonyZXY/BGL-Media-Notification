//
//  TickerDataRealm.swift
//  news app for blockchain
//
//  Created by Sheng Li on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

class TickerDataRealm: Object {
    @objc dynamic var symbol = ""
    @objc dynamic var name = ""
    @objc dynamic var price = 0.0
    @objc dynamic var percent_change_1h = 0.0
    @objc dynamic var percent_change_24h = 0.0
    @objc dynamic var percent_change_7d = 0.0
    @objc dynamic var volume_24h = 0.0
    @objc dynamic var market_cap = 0.0
    @objc dynamic var circulating_supply = 0.0
    @objc dynamic var usd_price = 0.0
    @objc dynamic var usd_volume_24h = 0.0
    @objc dynamic var usd_market_cap = 0.0
    
    override class func primaryKey() -> String {
        return "symbol"
    }
}
