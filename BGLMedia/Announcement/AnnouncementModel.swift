//
//  AnnouncementApiReader.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 14/11/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AnnouncementModel{
    var publishedTime : Date?
    var _id : String = ""
    var timeTo : Date?
    var timeFrom : Date?
    var title : String?
    var shortMessage : String?
    
    init(_ json : JSON) {
        publishedTime = Extension.method.convertStringToDate(date: json["publishedTime"].string ?? "")
        _id = json["_id"].string ?? ""
        timeTo = Extension.method.convertStringToDate(date: json["timeTo"].string ?? "")
        timeFrom = Extension.method.convertStringToDate(date: json["timeFrom"].string ?? "")
        title = json["title"].string ?? ""
        shortMessage = json["shortMassage"].string ?? ""
    }
}


class AnnouncementApiReader{
    
    func getAllAnouncement(completion: @escaping ([AnnouncementModel],Bool) -> (Void)){
        
        URLServices.fetchInstance.passServerData(urlParameters: ["game","notification"], httpMethod: "GET", parameters: [:], completion: {(res,success) in
            if success {
                if let array = res.array {
                    var models = [AnnouncementModel]()
                    models.removeAll()
            
                    for obj in array{
                        models.append(AnnouncementModel(obj))
                    }
                    
                    completion(models,true)
                }else{
                    completion([],false)
                }
                

            }else{
                print("unable to get announcement")
                completion([],false)
            }
        })
    }
}

