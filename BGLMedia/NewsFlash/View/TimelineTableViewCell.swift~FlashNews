//
//  TimelineTableViewCell.swift
//  TimelineTableViewCell
//
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//

import UIKit

open class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak open var titleLabel: UILabel!
    @IBOutlet weak open var descriptionLabel: UILabel!
    @IBOutlet weak open var lineInfoLabel: UILabel!
    @IBOutlet weak open var thumbnailImageView: UIImageView!
    @IBOutlet weak open var illustrationImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    
    
    open var timelinePoint = TimelinePoint() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    open var timelinePointInside = TimelinePoint() {
        didSet {
            self.setNeedsDisplay()
        }
    }

    open var timeline = Timeline() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var bubbleColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    override open func draw(_ rect: CGRect) {
        for layer in self.contentView.layer.sublayers! {
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        lineInfoLabel.sizeToFit()
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
    
        
        timelinePoint.position = CGPoint(x: timeline.leftMargin + timeline.width / 2, y: timelinePoint.lineWidth)
        
        timeline.start = CGPoint(x: timelinePoint.position.x + timelinePoint.diameter / 2, y: timelinePoint.position.y + timelinePoint.diameter)
        timeline.end = CGPoint(x: timeline.start.x, y: self.bounds.size.height)
        timeline.draw(view: self.contentView)
        
        timelinePoint.draw(view: self.contentView)
        
        if timelinePointInside.insidePoint {
            timelinePointInside.position = CGPoint(x: timelinePoint.position.x + (timelinePoint.diameter - timelinePointInside.diameter) / 2,
                                                   y: timelinePoint.position.y + (timelinePoint.diameter - timelinePointInside.diameter) / 2)
            timelinePointInside.draw(view: self.contentView)
        }
    }
}
