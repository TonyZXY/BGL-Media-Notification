//
//  File.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 9/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

/**
 requsets
 7. set stop loss pair
 EndPoint: <host>/game/setStopLoss
 Method: POST
 Body: {
    token: <verifyToken>,
    email:<userEmail>,
    user_id:<user_id>,
    set:{
        coinName:<coin name in lower case e.g. btc>,
        priceGreater:<price greater to sell>,
        priceLower:<price lower to sell>,
        amount: <amount of coin>,
    }
 }
 
 8. Get Stop Loss Pair for User:
 EndPoint: <host>/game/getStopLossList
 Method: POST
 Body: {
    token: <verifyToken>,
    email:<userEmail>,
    user_id:<user_id>
 }

 14. Update Stop Loss Set
 EndPoint: <host>/game/editStopLoss
 Method: POST
 Body: {
    token: <verifyToken>,
    email:<userEmail>,
    user_id:<user_id>,
    set:{
        set_id:<set_id sent from server>,
        coinName:<coin name in lower case e.g. eth>,
        priceGreater:<price greater>,
        priceLower:<price lower>,
        amount:<amount of coin>
    }
 }
 */

class StopLossObject: Object {
    @objc dynamic var set_id : String = "0"
    @objc dynamic var user_id: String = "0"
    @objc dynamic var coinAbbrName: String = ""
    @objc dynamic var price_greater : Double = 0
    @objc dynamic var price_lower : Double = 0
    @objc dynamic var amount : Double = 0
    
    /** if actived = false, means this stop loss is successfully proceed, and complete_date is the time that this stop loss complete. */
    @objc dynamic var actived : Bool = true
    @objc dynamic var complete_date: Date = Date()
    /** if code = 400, means this stop loss failed due to insufficient amount.  empty string means server return nil */
    @objc dynamic var code : String?
    
    override class func primaryKey() -> String {
        return "set_id"
    }
}

class  StopLossApiService{
//    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOjEwMDAwMDAwLCJwYXNzd29yZCI6ImM4NzdhYzFlOGM5YTM5NDU0ZmNlMDk0NGFjMTk5NmQxZmY4ZmQ2NzdmNTFmYTg4NWZkNzJlYjEyYWQwZDk1N2IiLCJpYXQiOjE1Mzg0NDA5Nzd9.r6tWVPgo7vSqEu4M4jbVs4-vNiAL8Zralg7J3yS0ZdY"
//    let email = "xyzheng109@gmail.com"
//    let user_id = 10000000
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
    
    /**
        sent stopLoss setting to server
        - Parameters:
            - coinAbbr : coin abbriviation name in lower case e.g. btc
            - priceGreater : coin is automatically sold when greater than this value
            - priceLower : coin is automatically sold when lower than this value
            - amount : the amount of coin for automatic sell
            - completion : completion handler
                - success code(true)
                    - 200 "successfully add stop loss pair"
                - error code(false)
                    - 450  "User cannot set pair due to limitation"
                    - 500 "bad request",
                    - 510 "Database Error"
     */
    func setStopLoss(coinAbbr: String, priceGreater : Double, priceLower : Double, amount: Double, completion: @escaping (Bool,String) -> (Void)){
        let abbrName = coinAbbr.lowercased()
        let set : [String : Any] = ["coinName":abbrName,"priceGreater" : priceGreater, "priceLower": priceLower, "amount": amount]
        URLServices.fetchInstance.passServerData(urlParameters: ["game","setStopLoss"], httpMethod: "POST", parameters: ["token": token,"email": email,"user_id": user_id, "set": set]){ (res,success) in
            if success{
                
                let json = JSON(res)
                print(json)
                let code = json["code"].stringValue

                if code == "450" {
                    // due to limitation
                    print("失败设置StopLoss")
                    completion(false,code)
                }else{
                    print("成功设置StopLoss")
                    completion(true,code)
                }
            } else{
                print("失败设置StopLoss")
                let json = JSON(res)
                let code = json["code"].stringValue
                completion(false,code)
            }
        }
    }
    
    /**
        get all stoploss setting for the user
        - Parameters:
            - completion : completion handler
                - success code(true)
                    - 200 "successfully get stop loss pair"
                - error code(false)
                    - 500 "bad request",
                    - 510 "Database Error"
                    - 999 ""
     */
    func getStopLossList(completion: @escaping (Bool,String) -> (Void)){
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getStopLossList"], httpMethod: "POST", parameters: ["token": token,"email": email,"user_id": user_id]){ (res,success) in
            if success{
                
                // store data
                let json = JSON(res)
                let code = json["code"].stringValue
                let data = res["data"]
                
                // store data into realm
                print("成功获取StopLoss")
                
                self.storeDataToRealm(data: data, completion: {success in
                    if success {
                        // not expecting false from store to realm
                        completion(true,code)
                    }
                })
            } else{
                print("失败获取StopLoss")
                let json = JSON(res)
                let code = json["code"].stringValue
                completion(false,code)
            }
        }
    }
    
    private func storeDataToRealm(data:JSON,completion: @escaping (Bool)->Void){
        let realm = try! Realm()
        realm.beginWrite()
        //removing out dated data
        let removeResults = realm.objects(StopLossObject.self)
        realm.delete(removeResults)
        
        if let collection = data.array {
            for result in collection{
                let set_id = result["set_id"].stringValue
                let user_id = result["user_id"].stringValue
                let coin_name = result["coin_name"].string?.lowercased() ?? ""
                let price_greater = result["price_greater"].double ?? 0
                let price_lower = result["price_lower"].double ?? 0
                let amount = result["amount"].double ?? 0
                let actived = result["actived"].bool ?? true
                let complete_date = Extension.method.convertStringToDate(date: result["complete_date"].string ?? "")
                let code = result["code"].stringValue
                
                // if object not stored
                if(realm.object(ofType: StopLossObject.self, forPrimaryKey: set_id) == nil){
                    realm.create(StopLossObject.self, value: [set_id, user_id, coin_name, price_greater, price_lower, amount, actived, complete_date, code])
                } else {
                    realm.create(StopLossObject.self, value: [set_id, user_id, coin_name, price_greater, price_lower, amount, actived, complete_date, code], update: true)
                }
            }
            try! realm.commitWrite()
            completion(true)
        }
    }
    
    /**
        edit the stoploss setting for selected pair
        - Parameters:
            - set_id : id of the selected stoploss pair
            - coinAbbr : coin abbriviation name in lower case e.g. btc
            - priceGreater : coin is automatically sold when greater than this value
            - priceLower : coin is automatically sold when lower than this value
            - amount : the amount of coin for automatic sell
            - completion : completion handler
                - success code(true)
                    - 200 "successfully update stop loss set"
                - error code(false)
                    - 500 "bad request",
                    - 510 "Database Error"
     */
    func editStopLoss(set_id: String, coinAbbr: String, priceGreater : Double, priceLower : Double, amount: Double, completion: @escaping (Bool,String) -> (Void)){
        //            var token = UserDefaults.standard.string(forKey: "CertificateToken")
        //            var email = UserDefaults.standard.string(forKey: "UserEmail")
        let abbrName = coinAbbr.lowercased()
        let set : [String : Any] = ["set_id": set_id, "coinName":abbrName,"priceGreater" : priceGreater, "priceLower": priceLower, "amount": amount]
        URLServices.fetchInstance.passServerData(urlParameters: ["game","editStopLoss"], httpMethod: "POST", parameters: ["token": token,"email": email,"user_id": user_id, "set": set]){ (res,success) in
            if success{
                print("成功修改StopLoss")
                let json = JSON(res)
                print(json)
                let code = json["code"].stringValue
                completion(true,code)
                
            } else{
                print("失败修改StopLoss")
                let json = JSON(res)
                let code = json["code"].stringValue
                completion(false,code)
            }
        }
    }
}

