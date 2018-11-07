//
//  File.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 23/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON
/**
 responsible for getting all rankdata into dataModel and also responsible to covert dataModel to viewModel
 */
class RankDataReader {
    var rankInfoModel = RankDetailModel()
    var weeklyRankModels = [RankObjectModel]()
    var totalRankModels = [RankObjectModel]()
    var userRankModel = RankObjectModel()
    
    var token :String {
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? ""
        }
    }
    var email :String {
        get{
            return UserDefaults.standard.string(forKey: "UserEmail") ?? ""
        }
    }
    var user_id : Int{
        get{
            return UserDefaults.standard.integer(forKey: "user_id")
        }
    }
    
    func getAllRankData(completion: @escaping (Bool) -> (Void)){
//        print(token)
//        print(email)
//        print(user_id)
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getRanking"], httpMethod: "POST", parameters: ["token": token,"email": email,"user_id": user_id]){ (res,success) in
            if success{
                print("成功获取Ranking")
                self.clearAllData()
                // store data
                var data = JSON(res)["data"]
                print(data)
//                self.rankInfoModel = RankDetailModel(data)
//                //                    print(data)
//                // both ranking data are array
//                let weekly_rank = data["weekly_rank"].array ?? []
//                let total_rank = data["total_rank"].array ?? []
//                //user rank is a single object
//                let user_rank = data["user_rank"]
//
//                self.userRankModel = RankObjectModel(user_rank)
//
//                for obj in weekly_rank{
//                    let rank = RankObjectModel(obj)
//                    self.weeklyRankModels.append(rank)
//                }
//
//                for obj in total_rank{
//                    let rank = RankObjectModel(obj)
//                    //                        print(rank.total)
//                    self.totalRankModels.append(rank)
//                }
                
                completion(true)
                
            } else{
                print("失败获取Ranking")
                completion(false)
            }
        }
    }
    
    func clearAllData(){
        self.rankInfoModel = RankDetailModel()
        self.weeklyRankModels.removeAll()
        self.totalRankModels.removeAll()
        self.userRankModel = RankObjectModel()
    }
    // function that returns the viewmodels we want to display
    func convertToViewModels(rankModels: [RankObjectModel], displayMode: RankObjectViewModel.DisplayMode)->[RankObjectViewModel]{
        var viewModels = [RankObjectViewModel]()
        for rankModel in rankModels{
            viewModels.append(RankObjectViewModel(rankModel, displayMode: displayMode))
        }
        return viewModels
    }
    
    func getWeeklyViewModels()->[RankObjectViewModel]{
        return self.convertToViewModels(rankModels: weeklyRankModels, displayMode: RankObjectViewModel.DisplayMode.weekly)
    }
    
    func getTotalViewModels()->[RankObjectViewModel]{
        return self.convertToViewModels(rankModels: totalRankModels, displayMode: RankObjectViewModel.DisplayMode.total)
    }
    
    func getUserWeeklyViewModel()->RankObjectViewModel{
        return RankObjectViewModel(userRankModel, displayMode: RankObjectViewModel.DisplayMode.weekly)
    }
    
    func getUserTotalViewModel()->RankObjectViewModel{
        return RankObjectViewModel(userRankModel, displayMode: RankObjectViewModel.DisplayMode.total)
    }
}
