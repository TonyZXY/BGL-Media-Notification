//
//  ContainerView.swift
//  DetailCandleStickChart
//
//  This view is to display vertical and horizontal tick for chart
//
//  Created by Sheng Li on 24/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class ContainerView: UIView {
    // MARK: Data Variables
    private var historicalDataStruct: HistoricalDataStruct?
    
    private var marginHeight: CGFloat?
    
    private var xAxisHeight: CGFloat?
    
    private var chartHeight: CGFloat? {
        get {
            if let marginHeight = self.marginHeight, let xAxisHeight = self.xAxisHeight {
                return self.frame.size.height - marginHeight * 2 - xAxisHeight
            }
            return nil
        }
    }
    
    private var xAxisSelectedDataIndex: [Int]? {
        get {
            return historicalDataStruct?.xAxisSelectedDataIndex
        }
    }
    
    private var priceTickYPositions: [CGFloat]? {
        get {
            if let basePosition = marginHeight,
                let historicalDataStruct = historicalDataStruct,
                let highest = historicalDataStruct.highest,
                let chartHeight = chartHeight,
                let priceRange = historicalDataStruct.priceRange {
                return historicalDataStruct.yAxisPrices?.compactMap {
                    basePosition + CGFloat(highest - $0) * chartHeight / CGFloat(priceRange)
                }
            }
            return nil
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
    
    
    
    // MARK: Draw functions
    func configure(historicalDataStruct: HistoricalDataStruct?, xAxisHeight: CGFloat, marginUpperAndLowerChart: CGFloat) {
        self.historicalDataStruct = historicalDataStruct
        self.marginHeight = marginUpperAndLowerChart
        self.xAxisHeight = xAxisHeight
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if let priceTickYPositions = self.priceTickYPositions, let xAxisHeight = self.xAxisHeight {
            for yPosition in priceTickYPositions {
                addLine(fromPoint: CGPoint(x: 0.0, y: yPosition), toPoint: CGPoint(x: self.frame.size.width, y: yPosition), name: "priceTick")
            }
            // Add bottom border line
            addLine(fromPoint: CGPoint(x: 0.0, y: self.frame.size.height - xAxisHeight), toPoint: CGPoint(x: self.frame.size.width, y: self.frame.size.height - xAxisHeight), name: "priceTick")
        }
        if let timeTickXPositions = self.timeTickXPositions, let xAxisHeight = self.xAxisHeight {
            for xPosition in timeTickXPositions {
                addLine(fromPoint: CGPoint(x: xPosition, y: 0), toPoint: CGPoint(x: xPosition, y: self.frame.size.height - xAxisHeight), name: "timeTick")
            }
            // Add right border line
            addLine(fromPoint: CGPoint(x: self.frame.size.width, y: 0), toPoint: CGPoint(x: self.frame.size.width, y: self.frame.size.height - xAxisHeight), name: "timeTick")
        }
    }
    
    private func addLine(fromPoint start: CGPoint, toPoint end:CGPoint, name: String) {
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        linePath.lineWidth = 0.5
        linePath.close()
        UIColor.gray.set()
        linePath.stroke()
        linePath.fill()
    }
}
