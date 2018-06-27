//
//  HistoricalDataStruct.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 18/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit

struct HistoricalDataStruct: Codable {
    var Data = [candleStickUnit?]()
    
    struct candleStickUnit: Codable {
        let time: Int
        var close: Double
        var high: Double
        var low: Double
        var open: Double
    }
    
    init?(json: Data?) // take some JSON and try to init an EmojiArt from it
    {
        if let data = json, let newValue = try? JSONDecoder().decode(HistoricalDataStruct.self, from: data) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(data: [candleStickUnit?]) {
        self.Data = data
    }
}

extension HistoricalDataStruct {
    var selectedData: [candleStickUnit?] {
        var data = [HistoricalDataStruct.candleStickUnit]()
        var count = 0
        // Set close of previous equal to open of latest
        var latestOpen: Double?
        for index in stride(from: self.Data.count - 1, to: 0, by: -Params.interval) {
            if var dataUnit = self.Data[index] {
                let start = index - Params.interval + 1 > 0 ? index - Params.interval + 1 : 0
                
                let subArray = self.Data[start...index]
                dataUnit.high = subArray.compactMap { $0?.high }.max()!
                dataUnit.low = subArray.compactMap { $0?.low }.min()!
                
                if let open = latestOpen {
                    dataUnit.close = open
                }
                latestOpen = dataUnit.open
                data.append(dataUnit)
            }
            count += 1
            if count == Params.amountOfCandlesDisplayed * Params.multipleData {
                break
            }
        }
        return data.reversed()
    }
    
    var highest: Double? {
        return selectedData.compactMap { $0?.high }.max()
    }
    
    var lowest: Double? {
        return selectedData.compactMap { $0?.low }.min()
    }
    
    var priceRange: Double? {
        if let highest = highest, let lowest = lowest {
            return highest - lowest
        }
        return nil
    }
    
    var yAxisPrices: [Double]? {
        if let range = priceRange, let base = lowest {
            var prices = [Double]()
            prices.append(range * Double(0.5) / Double(Params.numberOfYAxisLabels) + base)
            for factor in 1...(Params.numberOfYAxisLabels - 2) {
                prices.append(range * (Double(factor) + Double(0.5)) / Double(Params.numberOfYAxisLabels) + base)
            }
            prices.append(range * (Double(Params.numberOfYAxisLabels) - Double(0.5)) / Double(Params.numberOfYAxisLabels) + base)
            return prices
        }
        return nil
    }
    
    var dates: [String]? {
        let converter = DateTimeConverter()
        let dates:[String] = selectedData.compactMap {
            if let data = $0 {
                return converter.convert(timestamp: Double(data.time))
            }
            return nil
        }
        return dates
    }
    
    var xAxisSelectedDataIndex: [Int] {
        var indexes = [Int]()
        for index in stride(from: 4, to: self.selectedData.count, by: 7) {
            indexes.append(index)
        }
        return indexes
    }
    
    // self.frame.size.width * timeTickXPositionsRatio
    var timeTickXPositionsRatio: [CGFloat] {
        get {
            return xAxisSelectedDataIndex.compactMap {
                CGFloat(Double($0) * 2.0 + 0.5) / CGFloat(Params.amountOfCandlesDisplayed * Params.multipleData * 2)
            }
        }
    }
}
