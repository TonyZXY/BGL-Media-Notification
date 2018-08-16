//
//  DateTimeConverter.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 20/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation

class DateTimeConverter {
    var strDate = ""
    let dateFormat = ["HH:mm", "HH:mm", "MM/dd", "MM/dd"]
    
    func convert(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat[Params.category]
        strDate = dateFormatter.string(from: date)
        return strDate
    }
}
