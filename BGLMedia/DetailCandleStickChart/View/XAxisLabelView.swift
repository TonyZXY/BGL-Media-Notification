//
//  XAxisLabelView.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 24/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class XAxisLabelView: UIView {
    private var historicalDataStruct: HistoricalDataStruct?
    
    private var dates: [String]? {
        get {
            return historicalDataStruct?.dates
        }
    }
    
    private var indexes: [Int]? {
        get {
            return historicalDataStruct?.xAxisSelectedDataIndex
        }
    }
    
    private var timeTickXPositions: [CGFloat]? {
        if let ratio = self.historicalDataStruct?.timeTickXPositionsRatio {
            return ratio.map {
                $0 * self.frame.size.width
            }
        }
        return nil
    }
    
    func configure(historicalDataStruct: HistoricalDataStruct?) {
        self.historicalDataStruct = historicalDataStruct
        addLabel()
    }
    
    func addLabel() {
        guard let dates = self.dates else { return }
        guard let xPositions = self.timeTickXPositions else { return }
        guard let indexes = self.indexes else { return }
        for index in 0..<xPositions.count {
            let label = UILabel()
            label.text = dates[indexes[index]]
            label.textColor = .gray
            label.font = label.font.withSize(10)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.sizeToFit()
            self.addSubview(label)
            
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: xPositions[index]).isActive = true
        }
    }
}
