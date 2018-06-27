//
//  defCurrency.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import RealmSwift

class defCurrency: Object {
    @objc dynamic var id = ""
    @objc dynamic var defCur = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
}
