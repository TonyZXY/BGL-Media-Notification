//
//  AlertCoinName.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 27/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

class alertCoinNames:Object{
    @objc dynamic var coinName:String = ""
    
    override class func primaryKey() -> String {
        return "coinName"
    }
}
