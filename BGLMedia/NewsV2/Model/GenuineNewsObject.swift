//
//  NewsSliderObject.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 2018/9/12.
//  Copyright © 2018年 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift

class GenuineNewsObject : Object{
    @objc dynamic var _id: String? = ""
    @objc dynamic var author: String? = ""
    @objc dynamic var genuineDescription: String? = ""
    @objc dynamic var imageURL: String? = ""
    @objc dynamic var url: String? = ""
    @objc dynamic var genuineTag: String? = ""
    @objc dynamic var publishedTime: Date = Date()
    @objc dynamic var languageTag: String? = ""
    
    override class func primaryKey() -> String {
        return "_id"
    }
    
}
