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
    
    
    
    private var Data:[candleStickUnit?]?
    private var data:[candleStickUnit?]?
//    var data = [candleStickUnit?]()
    
    struct candleStickUnit: Codable {
        var id:Int?
        var time: Int?
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
    
    func candleStickData() -> [candleStickUnit?]? {
        return Data ?? data
    }
}

extension HistoricalDataStruct {
    var selectedData: [candleStickUnit?] {
        var mutableData = [HistoricalDataStruct.candleStickUnit]()
        var count = 0
        // Set close of previous equal to open of latest
        var latestOpen: Double?
        guard var datas = self.candleStickData() else{return []}
        
        
        _ = candleStickUnit.self
        for index in stride(from: datas.count - 1, to: 0, by: -Params.interval) {
            if var dataUnit = datas[index] {
                let start = index - Params.interval + 1 > 0 ? index - Params.interval + 1 : 0
                var subArray = datas[start...index]
                dataUnit.high = subArray.compactMap { $0?.high }.max()!
                dataUnit.low = subArray.compactMap { $0?.low }.min()!
                
                if Params.interval == 7{
                    let errorData = subArray.filter{ $0?.high ?? 0 > ($0?.low) ?? 0 * 10}
                    if errorData.count != 0 && subArray.count != 0{
                        subArray.sort(){ Int($0?.high ?? 0) > Int($1?.high ?? 0)}
                        subArray.sort(){ Int($0?.high ?? 0) > Int($1?.high ?? 0)}
                        subArray.removeFirst()
                        dataUnit.high = subArray.first??.high ?? 0
                    }
                }
                if let open = latestOpen {
                    dataUnit.close = open
                }
                latestOpen = dataUnit.open
                mutableData.append(dataUnit)
            }
            count += 1
            if count == Params.amountOfCandlesDisplayed * Params.multipleData {
                break
            }
        }
        
       //Fill empty data to HuobiAU
        let dataCount = mutableData.count
        let displayCount = Params.amountOfCandlesDisplayed * Params.multipleData
        if dataCount < displayCount{
            let minPrice:Double = Double(mutableData.map{$0.low}.min() ?? 0)
            var emptyArray = [Int]()
            if let earlyTimestamp = Int?(mutableData.map{$0.id ?? 0}.min() ?? 0){
                var lastTimestamp = earlyTimestamp
                for _ in 1...(displayCount-dataCount){
                    lastTimestamp = lastTimestamp - 604800
                    emptyArray.append(lastTimestamp)
                }
            }
            
            if mutableData.count == 13{
                for result in emptyArray{
                    mutableData.append(candleStickUnit.init(id: result, time: nil, close: minPrice, high: minPrice, low: minPrice, open: minPrice))
                }
            }
        }
//        var ii = [Int]()
//        for ss in mutableData.reversed(){
//            ii.append(ss.time ?? ss.id ?? 0)
//        }
//        print(ii)
        return mutableData.reversed()
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
                return converter.convert(timestamp: Double(data.time ?? data.id!))
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
