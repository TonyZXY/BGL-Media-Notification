//
//  NewsInFlashNewsRealm.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 13/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import Foundation
import RealmSwift

class NewsInFlashNewsRealm: Object {
    @objc dynamic var symbol = ""
    override class func primaryKey() -> String {
        return "symbol"
    }
}
