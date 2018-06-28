//
//  Video.swift
//  news app for blockchain
//
//  Created by Xuyang Zheng on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class Video: Object {
    @objc dynamic var _id: String? = ""
    @objc dynamic var title: String? = ""
    @objc dynamic var videoDescription: String? = ""
    @objc dynamic var imageURL: String? = ""
    @objc dynamic var url: String? = ""
    @objc dynamic var publishedTime: String? = ""
    @objc dynamic var author: String? = ""
    @objc dynamic var localeTag: String? = ""
    @objc dynamic var typeTag: String? = ""
    @objc dynamic var languageTag:String? = ""
    
    override class func primaryKey() -> String {
        return "_id"
    }
}
