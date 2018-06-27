//
//  defDisplayOpt.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

class defDisplayOpt: Object {
    @objc dynamic var displayId = ""
    @objc dynamic var defDisplayPage = ""
    
    override class func primaryKey() -> String {
        return "displayId"
    }
}
