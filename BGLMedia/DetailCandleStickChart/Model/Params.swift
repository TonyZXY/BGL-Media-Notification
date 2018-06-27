//
//  IntervalParams.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 19/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation

struct Params {
    static var intervalText = "30分钟"
    static let intervalTexts = ["30分钟", "4小时", "日", "周"]
    static var intervalParam = "histominute"
    static var interval = 30
    static var category = 0 {
        didSet {
            intervalText = intervalTexts[category]
            intervalParam = ["histominute", "histohour", "histoday", "histoday"][category]
            interval = [30, 4, 1, 7][category]
        }
    }
    static var amountOfCandlesDisplayed = 30
    static var multipleData = 2
    static var numberOfYAxisLabels = 6
    static var numberofXAxisLabels = 4
}
