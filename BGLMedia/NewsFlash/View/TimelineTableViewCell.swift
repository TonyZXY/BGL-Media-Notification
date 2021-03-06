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
//    @IBOutlet weak open var lineInfoLabel: UILabel!
//    @IBOutlet weak open var thumbnailImageView: UIImageView!
//    @IBOutlet weak open var illustrationImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var txtTitleLabel: UILabel!
    
    var object: NewsFlash?{
        didSet{
            let watchList = try!Realm().objects(NewsInFlashNewsRealm.self).filter("symbol = %@",object!.id)
            if watchList.count == 1 {
                likeButton.setTitle("❤️", for: .normal)
            } else {
                likeButton.setTitle("♡", for: .normal)
            }
            sharesbutton.setTitle(textValue(name: "share_flash"), for: .normal)
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
        setUpView()
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
        
        txtTitleLabel.sizeToFit()

//        lineInfoLabel.sizeToFit()
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
//        sharesbutton.sizeToFit()
        
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
        let likedList = try! Realm().objects(NewsInFlashNewsRealm.self).filter("symbol = %@", object!.id)
//        print(object?.contents ?? "Empty")
        realm.beginWrite()
//        print(likedList.count)
        if likedList.count == 1 {
            likeButton.setTitle("♡", for: .normal)
//            print("detected - remove like")
            realm.delete(likedList[0])
            
        } else {
            likeButton.setTitle("❤️", for: .normal)
            
//            print("no item found - add like")
            realm.create(NewsInFlashNewsRealm.self, value: [object!.id])
            
        }
        try! realm.commitWrite()
    }
    
    func setUpView(){
        titleLabel.font = UIFont.semiBoldFont(10)
        descriptionLabel.font = UIFont.regularFont(CGFloat(fontSize))
        txtTitleLabel.font = UIFont.boldFont(CGFloat(fontSize + 3))
        txtTitleLabel.numberOfLines = 0
        txtTitleLabel.lineBreakMode = .byWordWrapping
        txtTitleLabel.textColor = ThemeColor().whiteColor()
        addSubview(sharesbutton)
        NSLayoutConstraint(item: sharesbutton, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: sharesbutton, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        
        addSubview(likesButton)
        NSLayoutConstraint(item: likesButton, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: likesButton, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
//        shareButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        NSLayoutConstraint(item: sharesbutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30).isActive = true
//        NSLayoutConstraint(item: sharesbutton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 120).isActive = true
    }

    var sharesbutton:UIButton = {
//       var button = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        var button = UIButton()
        button.backgroundColor = ThemeColor().darkBlackColor()
        button.layer.cornerRadius = 15
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        button.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 20, 0)
//        but
        button.titleLabel!.font =  UIFont.semiBoldFont(10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(textValue(name: "share_flash"), for: .normal)
    
        button.setImage(UIImage(named: "share_.png"), for: .normal)
//        button.titleLabel?.font = UIFont(name: <#T##String#>, size: <#T##CGFloat#>)
//        button.imageView?.frame = CGRect(x: 5, y: 5, width: 5, height: 5)
//        button.transform = CGAffineTransform(scaleX: -1, y: 1)
//        button.transform = CGAffineTransform(scaleX: 1, y: -1)
        return button
    }()
    
    var likesButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = ThemeColor().darkBlackColor()
        button.layer.cornerRadius = 15
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        button.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 20, 0)
        //        but
        button.titleLabel!.font =  UIFont.semiBoldFont(10)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("551", for: .normal)
        
        button.setImage(UIImage(named: "likeButton.png"), for: .normal)
        return button
    }()
    
    
}
