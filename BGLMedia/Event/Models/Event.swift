//
//  Event.swift
//  BGLMedia
//
//  Created by Fan Wu on 9/17/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Event {
    let eventID: String
    let eventAddress: String
    let eventCity: String
    let eventDescription: String
    let eventCreatedTime: Date
    let eventEndTime: Date
    let eventHost: String
    let eventHostPage: String
    let eventImageURL: String
    let eventLati: String
    let eventLong: String
    let eventName: String
    let eventStartTime: Date
    let eventURL: String
    let logoURL: String
    
    
    init(_ json: JSON) {
        eventID = json["eventID"].stringValue
        eventAddress = json["eventAddress"].stringValue
        eventCity = json["eventCity"].stringValue
        eventDescription = json["eventDescription"].stringValue
        eventCreatedTime = Extension.method.convertStringToDate(date: json["eventCreatedTime"].stringValue)
        eventEndTime = Extension.method.convertStringToDate(date: json["eventEndTime"].stringValue)
        eventHost = json["eventHost"].stringValue
        eventHostPage = json["eventHostPage"].stringValue
        eventImageURL = json["eventImageURL"].stringValue
        eventLati = json["eventLati"].stringValue
        eventLong = json["eventLong"].stringValue
        eventName = json["eventName"].stringValue
        eventStartTime = Extension.method.convertStringToDate(date: json["eventStartTime"].stringValue)
        eventURL = json["eventURL"].stringValue
        logoURL = json["logoURL"].stringValue
    }
}
