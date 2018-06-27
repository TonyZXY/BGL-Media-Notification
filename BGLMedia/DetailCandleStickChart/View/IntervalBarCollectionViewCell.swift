//
//  IntervalBarCollectionViewCell.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 19/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class IntervalBarCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    lazy var label: UILabel = {
        var label = UILabel()
        label.textColor = .gray
        label.font = label.font.withSize(10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .black : .gray
            self.backgroundColor = isSelected ? .white : ThemeColor().themeColor()
        }
    }
    
    func setupView(){
        addSubview(label)
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
