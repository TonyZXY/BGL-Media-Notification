//
//  CandleStickChart.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 18/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class CandleStickChart: UIView {
    
    func configure(historicalDataStruct: HistoricalDataStruct?) {
        
        if let dataStruct = historicalDataStruct {
            
            var candleUnitsArray = [CandleStick]()
            
            let candleStickWidth = self.frame.width / CGFloat(Params.amountOfCandlesDisplayed) / 2 / CGFloat(Params.multipleData)
            
            candleUnitsArray = dataStruct.selectedData.map { data in
                let candleStick = CandleStick()
                candleStick.translatesAutoresizingMaskIntoConstraints = false
                candleStick.frame.size.height = self.frame.height
                candleStick.frame.size.width = candleStickWidth
                candleStick.configure(priceRange: dataStruct.priceRange, highest: dataStruct.highest, candleData: data)
                return candleStick
            }
            
            let stackView = UIStackView(arrangedSubviews: candleUnitsArray)
            stackView.frame.size.height = self.frame.height
            stackView.frame.size.width = self.frame.width
            stackView.spacing = candleStickWidth
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.alignment = .fill
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            self.addSubview(stackView)
            
            NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.frame.width).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.frame.height).isActive = true
        }
        
    }
}
