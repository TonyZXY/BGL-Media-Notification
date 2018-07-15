//
//  NewsObject.swift
//  BGLMedia
//
//  Created by Bruce Feng on 9/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class NewsObject: Object {
    @objc dynamic var _id: String? = ""
    @objc dynamic var title: String? = ""
    @objc dynamic var newsDescription: String? = ""
    @objc dynamic var imageURL: String? = ""
    @objc dynamic var url: String? = ""
    @objc dynamic var publishedTime: Date = Date()
    @objc dynamic var author: String? = ""
    @objc dynamic var localeTag: String? = ""
//    @objc dynamic var contentTag: String? = ""
    @objc dynamic var languageTag:String? = ""
    var contentTag = List<String>()
    
    override class func primaryKey() -> String {
        return "_id"
    }
}
