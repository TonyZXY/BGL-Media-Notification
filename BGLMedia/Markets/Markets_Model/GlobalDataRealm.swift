//
//  GlobalDataModel.swift
//  news app for blockchain
//
//  Created by Sheng Li on 7/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

class GlobalDataRealm: Object {
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
