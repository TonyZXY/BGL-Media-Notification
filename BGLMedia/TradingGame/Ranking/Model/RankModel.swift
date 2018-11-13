//
//  File.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 2/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RankDetailModel {
    var date_number : Int = -1
    var time_string : String = ""
    var title : String = ""
    var time : Date = Date()

    init(_ rankJson: JSON? = nil) {
        if var json = rankJson{
            date_number = json["date_number"].int ?? -1
            time_string = json["time_string"].string ?? ""
            title = json["title"].string ?? ""
            time = Extension.method.convertStringToDate(date: json["time"].string ?? "")
        }
    }
}

struct CompetitionRankModel {
    var _id : String = ""
    var user_id : String = ""
    var user_nickname : String = ""
    var daily_rank : Int = -1
    var this_week : Double = -1
    
    init(_ competitionData : JSON?) {
        if let json = competitionData {
            _id = json["_id"].string ?? ""
            user_id = json["user_id"].string ?? ""
            user_nickname = json["user_nickname"].string ?? ""
            daily_rank = json["daily_rank"].int ?? -1
            this_week = json["this_week"].double ?? -1
            this_week -= 100
        }
    }
}

struct TotalRankModel {
    var _id : String = ""
    var user_id : String = ""
    var user_nickname : String = ""
    var total_rank : Int = -1
    var total : Double = -1
    
    init(_ totalData : JSON?) {
        if let json = totalData {
            _id = json["_id"].string ?? ""
            user_id = json["user_id"].string ?? ""
            user_nickname = json["user_nickname"].string ?? ""
            total_rank = json["total_rank"].int ?? -1
            total = json["total"].double ?? -1
        }
    }
}

struct RankAllInfoModel{
    var total : TotalRankModel?
    var competition : CompetitionRankModel?
    var competition_detail : RankDetailModel?
    var total_detail : RankDetailModel?
    var totalRank : [TotalRankModel] = []
    var competitionRank : [CompetitionRankModel] = []
    
    init(_ result: JSON?=nil) {
        if var json = result {
            total = TotalRankModel(json["total"])
            competition = CompetitionRankModel(json["competition"])
            
            let competition_json = json["competitionRank"]
            let total_json = json["totalRank"]
            competition_detail = RankDetailModel(competition_json)
            total_detail = RankDetailModel(total_json)
            
            let competition_data = competition_json["data"].array ?? []
            let total_data = total_json["data"].array ?? []
            
            totalRank.removeAll()
            competitionRank.removeAll()
            for data in competition_data{
                competitionRank.append(CompetitionRankModel(data))
            }
            
            for data in total_data{
                totalRank.append(TotalRankModel(data))
            }
            
//            print(totalRank)
//            print(competitionRank)
        }
        // should go with default value if empty result
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
//    var pop_weeklyStat : String = ""
    var pop_stat : String = ""
    var pop_rank : String = ""
//    var pop_totalRank : String = ""

    init(totalModel : TotalRankModel) {
        nickname = totalModel.user_nickname
        ranknumber = totalModel.total_rank
        ranknumberString = "\(totalModel.total_rank)."
        statString = "$\(totalModel.total.toAbbreviateString(decimal: 3))"
    
        pop_title = nickname
        pop_stat = "$\(totalModel.total.floorTo(decimalLimit: 8))"
        pop_rank = "\(ranknumber)"
    }

    init(competitionModel: CompetitionRankModel){
        nickname = competitionModel.user_nickname
        ranknumber = competitionModel.daily_rank
        ranknumberString = "\(competitionModel.daily_rank)."
        statString = "\(competitionModel.this_week.floorTo(decimalLimit: 3))%"
        
        pop_title = nickname
        pop_stat = "\(competitionModel.this_week.floorTo(decimalLimit: 8))%"
        pop_rank = "\(ranknumber)"
    }
    
}

