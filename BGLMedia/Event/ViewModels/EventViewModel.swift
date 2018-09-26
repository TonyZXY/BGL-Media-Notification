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
    let address: String
    let eventStartTime: Date
    let eventEndTime: Date
    let description: String
    let hostPage: String
    let imageUrlStr: String
    let urlStr: String
    let yearOfEventStartTime: String
    let monthOfEventStartTime: String
    let weekOfEventStartTime: String
    let dayOfEventStartTime: String
    let timeOfEventStartTime: String
    let hostLabel: String
    let startTimeLabel: String
    let endTimeLabel: String
    var dateGroupType: String
    var hostFilter: String?
    
    init(event: Event) {
        let year = Calendar.current.component(.year, from: event.eventStartTime)
        let week = Calendar.current.component(.weekOfYear, from: event.eventStartTime)
        
        title = event.eventName
        host = event.eventHost
        address = {
            if event.eventAddress != "null" {
                return "\(event.eventAddress) \(event.eventCity)"
            }
            return "N/A"
        }()
        self.eventStartTime = event.eventStartTime
        self.eventEndTime = event.eventEndTime
        yearOfEventStartTime = String(year)
        monthOfEventStartTime = Extension.method.convertTimeToStringPickerDate3(date: event.eventStartTime)
        dayOfEventStartTime = Extension.method.convertDateToStringPickerDate(date: event.eventStartTime)
        timeOfEventStartTime = Extension.method.convertTimeToStringPickerDate2(date: event.eventStartTime)
        startTimeLabel = "\(dayOfEventStartTime) \(timeOfEventStartTime)"
        let dayOfEventEndTime = Extension.method.convertDateToStringPickerDate(date: event.eventStartTime)
        let timeOfEventEndTime = Extension.method.convertTimeToStringPickerDate2(date: event.eventStartTime)
        endTimeLabel = "\(dayOfEventEndTime) \(timeOfEventEndTime)"
        dateGroupType = dayOfEventStartTime
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
            hostLabel = host
        } else {
            hostLabel = "Unknown"
        }
    }
}
