//
//  VEvent.swift
//  BGLMedia
//
//  Created by Fan Wu on 9/18/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

struct EventViewModel {
    let title: String
    let host: String
    let hostLabel: String
    let address: String
    let eventStartTime: Date
    let yearOfEventStartTime: String
    let monthOfEventStartTime: String
    let weekOfEventStartTime: String
    let dayOfEventStartTime: String
    let timeOfEventStartTime: String
    let timeLabel: String
    var dateFilter: String
    let description: String
    let hostPage: String
    let imageUrlStr: String
    let urlStr: String
    
    init(event: Event) {
        let year = Calendar.current.component(.year, from: event.eventStartTime)
        let month = Calendar.current.component(.month, from: event.eventStartTime)
        let week = Calendar.current.component(.weekOfYear, from: event.eventStartTime)
        
        title = event.eventName
        host = event.eventHost
        address = "\(event.eventAddress) \(event.eventCity)"
        self.eventStartTime = event.eventStartTime
        yearOfEventStartTime = String(year)
        monthOfEventStartTime = "\(year)-\(month)"
        dayOfEventStartTime = Extension.method.convertDateToStringPickerDate(date: event.eventStartTime)
        timeOfEventStartTime = Extension.method.convertTimeToStringPickerDate2(date: event.eventStartTime)
        timeLabel = "\(dayOfEventStartTime) \(timeOfEventStartTime)"
        dateFilter = dayOfEventStartTime
        description = event.eventDescription
        hostPage = event.eventHostPage
        imageUrlStr = event.eventImageURL
        urlStr = event.eventURL
        
        let components = DateComponents(weekOfYear: week, yearForWeekOfYear: year)
        if let firstDayOfTheWeek = Calendar.current.date(from: components),
            let endDayOfTheWeek = Calendar.current.date(byAdding: .day, value: 6, to: firstDayOfTheWeek) {
            let strFirst = Extension.method.convertDateToStringPickerDate(date: firstDayOfTheWeek)
            let strEnd = Extension.method.convertDateToStringPickerDate(date: endDayOfTheWeek)
            weekOfEventStartTime = "\(strFirst) ~ \(strEnd)"
        } else {
            weekOfEventStartTime = "Unknown"
        }
        
        if host != "null" {
            hostLabel = "Host: \(host)"
        } else {
            hostLabel = "Unknown"
        }
    }
}
