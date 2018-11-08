//
//  File.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 2/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON

//struct RankDetailModel {
//    var title : String = ""
//    var rank_time : Date = Date()
//    var rank_time_string : String = ""
//    var week_number : Int = -1
//
//    init(_ json: JSON? = nil) {
//        if json != nil{
//            title = json!["title"].string ?? ""
//            rank_time = Extension.method.convertStringToDate(date: json!["rank_time"].string ?? "")
//            rank_time_string = json!["rank_time_string"].string ?? ""
//            week_number = json!["week_number"].int ?? -1
//        }
//    }
//}



struct RankObjectModel{
    var _id : String = ""
    var user_id : String = ""
    var user_nickname : String? = ""
    var total : Double = -1
    var week_percentage : Double = -1
    var week_rank : Int = -1
    var total_rank : Int = -1
    var rankType : RankType?
    
    enum RankType {
        case competition
        case total
    }
    init(_ json: JSON? = nil) {
        if json != nil{
            _id = json!["_id"].string ?? ""
            user_id = json!["user_id"].string ?? ""
            user_nickname = json!["user_nickname"].string ?? ""
            total = json!["total"].double ?? -1
            week_percentage = json!["week_percentage"].double ?? -1
            week_rank = json!["week_rank"].int ?? -1
            total_rank = json!["total_rank"].int ?? -1
        }
        // should go with default value if empty param
    }
}

struct RankObjectViewModel {
    // for dipslaying cell content
    var nickname : String = ""
    // sort with rank so keep int value
    var ranknumber : Int = -1
    var ranknumberString : String = ""
    var statString : String = ""
    
    // for displaying onclick pop window content
    var pop_title : String = ""
    var pop_weeklyStat : String = ""
    var pop_totalStat : String = ""
    var pop_weeklyRank : String = ""
    var pop_totalRank : String = ""
    
    enum DisplayMode {
        case weekly
        case total
    }
    
    
    init(_ rankModel: RankObjectModel, displayMode : DisplayMode) {
        if displayMode == DisplayMode.weekly{
            nickname = rankModel.user_nickname ?? ""
            ranknumber = rankModel.week_rank
            ranknumberString = "\(rankModel.week_rank)."
            statString = "\(String(format : "%.2f", rankModel.week_percentage))%"
        }
        if displayMode == DisplayMode.total {
            nickname = rankModel.user_nickname ?? ""
            ranknumber = rankModel.total_rank
            ranknumberString = "\(rankModel.total_rank)."
            statString = rankModel.total.toAbbreviateString(decimal: 2)
        }
        
        pop_title = nickname
        pop_weeklyRank = "\(rankModel.week_rank)"
        pop_totalRank = "\(rankModel.total_rank)"
        pop_weeklyStat = "\(String(format : "%.2f", rankModel.week_percentage))%"
        pop_totalStat = "\(rankModel.total)"
    }

}
