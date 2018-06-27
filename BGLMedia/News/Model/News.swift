//
//  News.swift
//  NewsApp2
//
//  Created by Xuyang Zheng on 27/4/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import RealmSwift

class News: Object {
    @objc dynamic var _id: String? = ""
    @objc dynamic var title: String? = ""
    @objc dynamic var newsDescription: String? = ""
    @objc dynamic var imageURL: String? = ""
    @objc dynamic var url: String? = ""
    @objc dynamic var publishedTime: String? = ""
    @objc dynamic var author: String? = ""
    @objc dynamic var localeTag: String? = ""
    @objc dynamic var contentTag: String? = ""

    override class func primaryKey() -> String {
        return "_id"
    }
}
