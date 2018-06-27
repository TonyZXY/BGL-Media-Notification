//
//  CandleStick.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 19/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class CandleStick: UIView {
    private var candleData: HistoricalDataStruct.candleStickUnit?
    private var priceRange: Double?
    private var highest: Double?
    
    private lazy var lineWidth = self.frame.width / 5
    private lazy var x = self.frame.width / 2
    private var color: CGColor? {
        get {
            if let open = candleData?.open, let close = candleData?.close {
                return open < close ? UIColor.green.cgColor : UIColor.red.cgColor
            }
            return nil
        }
    }
    private var stickYStart: CGFloat? {
        get {
            if let high = candleData?.high, let highest = highest, let priceRange = priceRange {
                return CGFloat((highest - high) / priceRange) * self.bounds.height
            }
            return nil
        }
    }
    private var stickYEnd: CGFloat? {
        get {
            if let low = candleData?.low, let highest = highest, let priceRange = priceRange {
                return CGFloat((highest - low) / priceRange) * self.bounds.height
            }
            return nil
        }
    }
    private var candleYStart: CGFloat? {
        get {
            if let open = candleData?.open, let highest = highest, let priceRange = priceRange {
                return CGFloat((highest - open) / priceRange) * self.bounds.height
            }
            return nil
        }
    }
    private var candleYEnd: CGFloat? {
        get {
            if let close = candleData?.close, let highest = highest, let priceRange = priceRange {
                var end = CGFloat((highest - close) / priceRange) * self.bounds.height
                // if end equals start, make a very short candle to display
                if end == candleYStart {
                    end += color == UIColor.green.cgColor ? -1 : 1
                }
                return end
            }
            return nil
        }
    }
    
    func configure(priceRange: Double?, highest: Double?, candleData: HistoricalDataStruct.candleStickUnit?) {
        self.priceRange = priceRange
        self.highest = highest
        self.candleData = candleData
        
        addLine(fromPoint: CGPoint(x: x, y: stickYStart!), toPoint: CGPoint(x: x, y: stickYEnd!), lineWidth: lineWidth)
        addLine(fromPoint: CGPoint(x: x, y: candleYStart!), toPoint: CGPoint(x: x, y: candleYEnd!), lineWidth: self.frame.width)
    }
    
    private func addLine(fromPoint start: CGPoint, toPoint end:CGPoint, lineWidth: CGFloat) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = color
        line.lineWidth = lineWidth
        self.layer.addSublayer(line)
    }
}
