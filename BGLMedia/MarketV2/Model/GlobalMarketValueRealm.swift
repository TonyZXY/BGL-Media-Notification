//
//  GlobalMarketValueRealm.swift
//  BGLMedia
//
//  Created by Bruce Feng on 12/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift

class GlobalMarketValueRealm: Object {
    @objc dynamic var bitcoin_percentage_of_market_cap = ""
    @objc dynamic var total_market_cap = ""
    @objc dynamic var total_volume_24h = ""

    // TODO:
    // Waiting to have historical time saved.

    @objc dynamic var id = "0"

    override static func primaryKey() -> String? {
        return "id"
    }
}
