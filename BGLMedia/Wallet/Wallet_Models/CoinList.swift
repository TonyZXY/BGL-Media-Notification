//
//  CoinList.swift
//  BGLMedia
//
//  Created by Bruce Feng on 11/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift

class CoinList:Object{
    @objc dynamic var id = ""
    @objc dynamic var coinName = ""
    @objc dynamic var coinSymbol = ""
    @objc dynamic var logoUrl = ""
    
    override class func primaryKey() -> String {
        return "coinSymbol"
    }
}
