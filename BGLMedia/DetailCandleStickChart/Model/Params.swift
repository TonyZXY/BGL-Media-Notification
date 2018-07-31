//
//  IntervalParams.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 19/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation

struct Params {
    static var intervalText = textValue(name: "chart30m_details")
    static var intervalTexts:[String]{
        get{
            return [textValue(name: "chart30m_details"), textValue(name: "chart4h_details"), textValue(name: "chart1d_details"), textValue(name: "chart1w_details")]
        }
    }
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
