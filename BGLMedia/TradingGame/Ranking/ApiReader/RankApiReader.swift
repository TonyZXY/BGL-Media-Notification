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
class RankApiReader {
    var rankData = RankAllInfoModel()
    // startAsset and totalValue is stored in this model
    var gameUser : GameUser?
    
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
    
    func processAllApis(completion: @escaping (Bool) -> (Void)){
        getAllRankData(completion: { success in
            if success {
                self.getAssetData(completion: { success2 in
                    if success2{
                        completion(true)
                    }else{
                        completion(false)
                    }
                })
            }else{
                completion(false)
            }
        })
    }
    
    func getAllRankData(completion: @escaping (Bool) -> (Void)){
//        print(token)
//        print(email)
//        print(user_id)
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getRanking"], httpMethod: "POST", parameters: ["token": token,"email": email,"user_id": user_id]){ (res,success) in
            if success{
                print("成功获取Ranking")
                // store data
                let data = JSON(res)["data"]
                
                self.rankData = RankAllInfoModel(data)
                
                completion(true)
                
            } else{
                print("失败获取Ranking")
                completion(false)
            }
        }
    }
    
    func getAssetData(completion: @escaping (Bool) -> (Void)) {
        
        let parameter = ["token": token, "email": email]
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","checkAccount"], httpMethod: "POST", parameters: parameter) { (response, success) in
            if success {
                if response["data"]["nick_name"].stringValue == "" {
                    completion(false)
                } else {
                    self.gameUser = GameUser(response)
                    self.getCoinPirce(completion: {success2 in
                        if success2 {
                            completion(true)
                        }else{
                            completion(false)
                        }
                    })

                }
            } else {
                completion(false)
            }
        }
    }
    
    func getCoinPirce(completion: @escaping (Bool) -> (Void)){
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getCoinData"], httpMethod: "GET", parameters: [:]) { (response, success) in
            
            if success {
                let dataArray = response["data"].array ?? []
                guard let coins = self.gameUser?.coins else {
                    completion(false)
                    return
                }
                
                for (index, _) in coins.enumerated() {
                    if coins[index].abbrName == "AUD" {
                        self.gameUser?.coins[index].price = 1
                    }
                    
                    if let coinDetail = dataArray.first(where: { (item) -> Bool in
                        item["coin_name"].stringValue == coins[index].abbrName.lowercased()
                    }) {
                        self.gameUser?.coins[index].price = coinDetail["current_price"].doubleValue
                    }
                }
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    // function that returns the viewmodels we want to display
    func convertToViewModels(totalModels: [TotalRankModel])->[RankObjectViewModel]{
        var viewModels = [RankObjectViewModel]()
        for model in totalModels{
            viewModels.append(RankObjectViewModel(totalModel: model))
        }
        return viewModels
    }
    
    // function that returns the viewmodels we want to display
    func convertToViewModels(competitionModels: [CompetitionRankModel])->[RankObjectViewModel]{
        var viewModels = [RankObjectViewModel]()
        for model in competitionModels{
            viewModels.append(RankObjectViewModel(competitionModel: model))
        }
        return viewModels
    }
    
    func getCompetitionViewModels()->[RankObjectViewModel]{
        return self.convertToViewModels(competitionModels: rankData.competitionRank)
    }
    
    func getTotalViewModels()->[RankObjectViewModel]{
        return self.convertToViewModels(totalModels: rankData.totalRank)
    }

    func getUserCompetitionViewModel()->RankObjectViewModel?{
        if let userCompetition = rankData.competition{
            return RankObjectViewModel(competitionModel: userCompetition)
        }
        return nil
    }

    func getUserTotalViewModel()->RankObjectViewModel?{
        if let userTotal = rankData.total{
            return RankObjectViewModel(totalModel: userTotal)
        }
        return nil
    }
}
