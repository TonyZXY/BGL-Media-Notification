//
//  ListViewCell.swift
//  BGLMedia
//
//  Created by Bruce Feng on 14/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher


class ListViewCell:UICollectionViewCell{
    var factor:CGFloat?{
        didSet{
            setupView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    func setupView(){
        backgroundColor = ThemeColor().darkGreyColor()
        addSubview(coinNameLabel)
        addSubview(volumeLabel)
        coinNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        coinNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        coinNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        coinNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        volumeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        volumeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        volumeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        volumeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init Error")
    }
    
    lazy var coinNameLabel:UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15)
//        label.text = "Name"
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var volumeLabel:UILabel = {
        var label = UILabel()
        label.text = "24 Hour"
        label.font = UIFont.semiBoldFont(15)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
