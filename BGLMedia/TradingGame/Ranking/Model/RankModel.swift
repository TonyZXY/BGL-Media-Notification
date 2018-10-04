//
//  File.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 2/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON

//class RankInfoObject:Object{
//
//    @objc dynamic var _id : String = ""
//    @objc dynamic var user_id : String = ""
//    @objc dynamic var user_nickname : String? = ""
//    @objc dynamic var total : Double = -1
//    @objc dynamic var week_percentage : Float = -1
//    @objc dynamic var week_rank : Int = -1
//    @objc dynamic var total_rank : Int = -1
//
//    override class func primaryKey() -> String {
//        return "_id"
//    }
//}

struct RankInfoModel {
    var title : String = ""
    var rank_time : Date = Date()
    var rank_time_string : String = ""
    var week_number : Int = -1
    
    init(_ json: JSON) {
        title = json["title"].string ?? ""
        rank_time = Extension.method.convertStringToDate(date: json["rank_time"].string ?? "")
        rank_time_string = json["rank_time_string"].string ?? ""
        week_number = json["week_number"].int ?? -1
    }
}

struct RankModel{
    var _id : String = ""
    var user_id : String = ""
    var user_nickname : String? = ""
    var total : Float = -1
    var week_percentage : Float = -1
    var week_rank : Int = -1
    var total_rank : Int = -1
    
    init(_ json:JSON) {
        _id = json["_id"].string ?? ""
        user_id = json["user_id"].string ?? ""
        user_nickname = json["user_nickname"].string ?? ""
        total = json["total"].float ?? -1
        week_percentage = json["week_percentage"].float ?? -1
        week_rank = json["week_rank"].int ?? -1
        total_rank = json["total_rank"].int ?? -1
    }
}
