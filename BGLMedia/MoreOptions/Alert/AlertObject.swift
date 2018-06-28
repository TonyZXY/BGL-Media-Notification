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
    @objc dynamic var compare:Double = 0
    @objc dynamic var status:Bool = true
    @objc dynamic var dateTime = Date()
    
    override class func primaryKey() -> String {
        return "id"
    }
}
