//
//  TotalValueCell.swift
//  BGLMedia
//
//  Created by Bruce Feng on 11/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class TotalMarketCell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //市场总资产
    let totalFunds:UILabel={
        var totalfunds = UILabel()
        totalfunds.sizeToFit()
        totalfunds.translatesAutoresizingMaskIntoConstraints = false
        totalfunds.font = totalfunds.font.withSize(13)
        totalfunds.textColor = ThemeColor().textGreycolor()
        return totalfunds
    }()
    
    let number:UILabel={
        var number = UILabel()
        number.translatesAutoresizingMaskIntoConstraints = false
        number.textColor = UIColor.white
        number.font = number.font.withSize(20)
        return number
    }()
    
    func setupView(){
        backgroundColor = ThemeColor().walletCellcolor()
        addSubview(totalFunds)
        addSubview(number)
        
        NSLayoutConstraint(item: totalFunds, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: number, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalFunds, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: number, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
