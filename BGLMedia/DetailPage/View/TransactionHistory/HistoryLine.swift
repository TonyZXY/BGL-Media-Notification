//
//  HistoryLine.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 14/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit

public struct HistoryLine {
    public var width: CGFloat = 2.0 {
        didSet {
            if (width < 0.0) {
                width = 0.0
            } else if(width > 20.0) {
                width = 20.0
            }
        }
    }
    
    public var (frontColor, backColor) = (UIColor.black, UIColor.black)
    
    internal var (start, end) = (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
    
    //    internal var leftMargin: CGFloat = 60.0
    internal var leftMargin: CGFloat = 20.0
    
    public init(width: CGFloat, frontColor: UIColor, backColor: UIColor) {
        self.width = width
        self.frontColor = frontColor
        self.backColor = backColor
    }
    
    public init(frontColor: UIColor, backColor: UIColor) {
        self.init(width: 2, frontColor: frontColor, backColor: backColor)
    }
    
    public init() {
        self.init(width: 2, frontColor: UIColor.black, backColor: UIColor.black)
    }
    
    public func draw(view: UIView) {
        draw(view: view, from: start, to: end, color: backColor)
    }
    
    fileprivate func draw(view: UIView, from: CGPoint, to: CGPoint, color: UIColor) {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        
        view.layer.addSublayer(shapeLayer)
    }
}

