//
//  RankTableViewCell.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 3/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankTableViewTopCell: UITableViewCell{
    public static let registerID = "rankTableViewTopCell"
    
    var goldContainer = TopRankContainer(imageName: "first")
    var silverContainer = TopRankContainer(imageName: "second")
    var bronzeContainer = TopRankContainer(imageName: "third")
    
    func setupView(){
        addSubview(silverContainer)
        addSubview(goldContainer)
        addSubview(bronzeContainer)
        // container width
        let cWidth = self.frame.width / 3
        let cHeight = self.frame.height
        addConstraintsWithFormat(format: "H:|[v0(\(cWidth))]-0-[v1(\(cWidth))]-0-[v2(\(cWidth))]", views: silverContainer,goldContainer,bronzeContainer)
        addConstraintsWithFormat(format: "V:|[v0(\(cHeight))]", views: silverContainer)
        addConstraintsWithFormat(format: "V:|[v0(\(cHeight))]", views: goldContainer)
        addConstraintsWithFormat(format: "V:|[v0(\(cHeight))]", views: bronzeContainer)
        
        silverContainer.changeImageSize(size: CGSize(width: 0.6*cWidth, height: 0.6*cWidth))
        goldContainer.changeImageSize(size: CGSize(width: 0.8*cWidth, height: 0.8*cWidth))
        bronzeContainer.changeImageSize(size: CGSize(width: 0.5*cWidth, height: 0.5*cWidth))
        
        // setup vertical constrainte for contents inside container
        silverContainer.addConstraintsWithFormat(format: "V:|-20-[v0]-0-[v1]-0-[v2]", views: silverContainer.medalImageView,silverContainer.playerNameLabel,silverContainer.statLabel)
        goldContainer.addConstraintsWithFormat(format: "V:|-10-[v0]-0-[v1]-0-[v2]", views: goldContainer.medalImageView,goldContainer.playerNameLabel,goldContainer.statLabel)
        bronzeContainer.addConstraintsWithFormat(format: "V:|-30-[v0]-0-[v1]-0-[v2]", views: bronzeContainer.medalImageView,bronzeContainer.playerNameLabel,bronzeContainer.statLabel)
    }
    
    
    class TopRankContainer : UIView{
        // set up image from init
        var medalImageView = UIImageView()
        
        var playerNameLabel : UILabel = {
            var label = UILabel()
            //            label.textColor = ThemeColor().whiteColor()
            label.numberOfLines =  1
            label.font = UIFont.semiBoldFont(CGFloat(fontSize))
            label.text = "Player Name"
            return label
        }()
        
        var statLabel: UILabel = {
            var label = UILabel()
            //            label.textColor = ThemeColor().whiteColor()
            label.numberOfLines =  1
            label.font = UIFont.semiBoldFont(CGFloat(fontSize))
            label.text = "Player Stats"
            return label
        }()
        
        private func setupImage(imageName:String){
            medalImageView.contentMode = .scaleAspectFit
            medalImageView.image = UIImage(named: imageName)
        }
        
        func changeImageSize(size: CGSize){
            medalImageView.image = medalImageView.image?.resizeImage(size)
            medalImageView.layer.cornerRadius = 0.5 * size.width
            medalImageView.clipsToBounds = true
        }
        
        
        // vertical constratints is setted out side in parent class
        func setupView(){
            addSubview(medalImageView)
            addSubview(playerNameLabel)
            addSubview(statLabel)
            
            medalImageView.translatesAutoresizingMaskIntoConstraints = false
            playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
            statLabel.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraint(NSLayoutConstraint(item: medalImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: playerNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: statLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        }
        
        convenience init(frame: CGRect?=nil, imageName:String){
            let defaultFrame :CGRect = CGRect(x: 0, y: 0, width: 100, height: 150)
            self.init(frame: frame ?? defaultFrame)
            setupImage(imageName: imageName)
            setupView()
        }
    }
}


class RankTableViewBottomCell : UITableViewCell{
    public static let registerID = "rankTableViewBottomCell"
    
    var rankNumberLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "-100."
        return label
    }()
    
    var playerNameLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "Player Default!!!!!"
        return label
    }()
    
    var playerStatLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.font = UIFont.semiBoldFont(CGFloat(fontSize))
        label.text = "-10000"
        return label
    }()
    
    func setupView(){
        addSubview(rankNumberLabel)
        addSubview(playerNameLabel)
        addSubview(playerStatLabel)
        
        // center alignment for vertical direction
        addConstraint(NSLayoutConstraint(item: rankNumberLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playerNameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: playerStatLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        let factor = self.frame.width/414
        
        addConstraintsWithFormat(format: "H:|-(\(10 * factor))-[v0(\(10 * factor))]-(\(10 * factor))-[v1(\(250 * factor))]", views: rankNumberLabel,playerNameLabel)
        addConstraintsWithFormat(format: "H:[v0(\(100 * factor))]-(\(10 * factor))-|", views: playerStatLabel)
    }
}
