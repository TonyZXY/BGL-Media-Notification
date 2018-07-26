//
//  GlobalFilterCollectionView.swift
//  BGLMedia
//
//  Created by Bruce Feng on 12/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit

class GlobalFilterCollectionView:UICollectionViewCell{

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
//        label.textColor = UIColor.black
//        self.backgroundColor = UIColor.white
//        let selectindexpath = NSIndexPath(item: 0, section: 0)
//        collectionView.selectItem(at: selectindexpath as IndexPath, animated: false, scrollPosition:.left)
    }
    
    lazy var label:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.regularFont(13*frame.width/50)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? ThemeColor().themeWidgetColor() : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? ThemeColor().whiteColor() : ThemeColor().textGreycolor()
            self.backgroundColor = isSelected ? ThemeColor().themeWidgetColor() : ThemeColor().themeColor()
        }
    }
    
    func setupView(){
        addSubview(label)
        
        self.layer.cornerRadius = 8 * frame.width/50
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
