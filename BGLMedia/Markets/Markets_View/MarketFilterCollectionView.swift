//
//  MarketSortPickView.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 1/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class MarketFilterCollectionView:UICollectionViewCell{

    var color = ThemeColor()
    
    var sortdate:[String]{
        get{
            return [textValue(name: "filterByWeek_market"),textValue(name: "filterByDay_market"),textValue(name: "filterByHour_market")]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    let label:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.gray
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            label.textColor = isHighlighted ? UIColor.white : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? UIColor.black : UIColor.gray
            self.backgroundColor = isSelected ? UIColor.white : color.themeColor()
        }
    }
    
    func setupView(){
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
