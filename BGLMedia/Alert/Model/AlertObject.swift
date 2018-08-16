//
//  AlertObject.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 22/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import Foundation
import RealmSwift

class alertObject:Object{
    @objc dynamic var id:Int = 0
    @objc dynamic var coinName = ""
    @objc dynamic var coinAbbName = ""
    @objc dynamic var tradingPairs = ""
    @objc dynamic var exchangName = ""
    @objc dynamic var price:Double = 0
    @objc dynamic var compareStatus:Int = 0
    @objc dynamic var switchStatus:Bool = true
    @objc dynamic var dateTime = Date()
    @objc dynamic var available = true
    
    override class func primaryKey() -> String {
        return "id"
    }
}

class alertObjects:Object{
    @objc dynamic var id:Int = 0
    @objc dynamic var coinName = ""
    @objc dynamic var coinAbbName = ""
    @objc dynamic var tradingPairs = ""
    @objc dynamic var exchangName = ""
    @objc dynamic var compare:Double = 0
    @objc dynamic var compareStatus:Int = 0
    @objc dynamic var switchStatus:Bool = true
    @objc dynamic var dateTime = Date()
    
}
