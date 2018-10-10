//
//  StopLossSettingView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 10/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class StopLossSetView : UIStackView{
    let factor = UIScreen.main.bounds.width/375
    
    lazy var priceUpperBound :UILabel = {
        var label = UILabel()
        label.font = UIFont.regularFont(13*factor)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLowerBound:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = UIFont.regularFont(15*factor)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
