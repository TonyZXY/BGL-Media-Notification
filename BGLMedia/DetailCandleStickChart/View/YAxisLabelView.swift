//
//  YAxisLabelView.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 23/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class YAxisLabelView: UIView {
    
    func configure(historicalDataStruct: HistoricalDataStruct?) {
        if let dataStruct = historicalDataStruct, let prices = dataStruct.yAxisPrices {
            var yLabels = [UILabel]()
            yLabels = prices.map { data in
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = String(format: "%.2f", data)
                label.textAlignment = .center
                label.textColor = .gray
                label.font = label.font.withSize(10)
                label.adjustsFontSizeToFitWidth = true
                yLabels.append(label)
                return label
                }.reversed()
            
            let stackView = UIStackView(arrangedSubviews: yLabels)
            stackView.frame.size.height = self.frame.height
            stackView.frame.size.width = self.frame.width
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.alignment = .fill
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            self.addSubview(stackView)
            
            NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.frame.width).isActive = true
            NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.frame.height).isActive = true
        }
    }
    
}
