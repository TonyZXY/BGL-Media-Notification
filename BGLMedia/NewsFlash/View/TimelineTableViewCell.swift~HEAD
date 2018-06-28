//
//  TimelineTableViewCell.swift
//  TimelineTableViewCell
//
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//

import UIKit
import RealmSwift

open class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak open var titleLabel: UILabel!
    @IBOutlet weak open var descriptionLabel: UILabel!
    @IBOutlet weak open var lineInfoLabel: UILabel!
    @IBOutlet weak open var thumbnailImageView: UIImageView!
    @IBOutlet weak open var illustrationImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!

    var object: NewsFlash?{
        didSet{
            let watchList = try!Realm().objects(NewsInFlashNewsRealm.self).filter("symbol = %@",object!.id)
            if watchList.count == 1 {
                likeButton.setTitle("❤️", for: .normal)
            } else {
                likeButton.setTitle("♡", for: .normal)
            }
        }
    }

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
        
//        likeButton.setTitle("♡", for: .normal)
        
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
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
    @objc func likeButtonClicked(){

        let realm = try! Realm()
        let watchList = try! Realm().objects(NewsInFlashNewsRealm.self).filter("symbol = %@", object!.id)
        print(object?.contents ?? "Empty")
        realm.beginWrite()
        print(watchList.count)
        if watchList.count == 1 {
//        if likeButton.currentTitle == "❤️"{
            likeButton.setTitle("♡", for: .normal)
//            realm.delete(watchList[0])
            print("detected - remove like")
            realm.delete(watchList[0])
            
        } else {
            likeButton.setTitle("❤️", for: .normal)
            
            print("no item found - add like")
            realm.create(NewsInFlashNewsRealm.self, value: [object!.id])
            
        }
        try! realm.commitWrite()
    }

}
