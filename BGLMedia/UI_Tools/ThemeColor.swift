//
//  Color.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 27/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class ThemeColor:UIColor{
    
    func themeColor() -> UIColor {
        _ = #colorLiteral(red: 0.1843137255, green: 0.1921568627, blue: 0.2117647059, alpha: 1)
        let color = UIColor.init(red:47/255.0, green:49/255.0, blue:54/255.0, alpha:1)
        return color
    }
    
    func riseColor() -> UIColor {
        _ = #colorLiteral(red: 0.1450980392, green: 0.6078431373, blue: 0.1411764706, alpha: 1)
        let color = UIColor.init(red:37/255.0, green:155/255.0, blue:36/255.0, alpha:1)
        return color
    }
  
    func fallColor() -> UIColor {
        _ = #colorLiteral(red: 0.8980392157, green: 0.1098039216, blue: 0.137254902, alpha: 1)
        let color = UIColor.init(red:229.0/255.0, green:28.0/255.0, blue:35.0/255.0, alpha:1)
        return color
    }
    
    func walletCellcolor() -> UIColor {
        _ = #colorLiteral(red: 0.2117647059, green: 0.2235294118, blue: 0.2431372549, alpha: 1)
        let color = UIColor.init(red:54/255.0, green:57/255.0, blue:62/255.0, alpha:1)
        return color
    }
    
    func greenColor() -> UIColor {
        _ = #colorLiteral(red: 0.1450980392, green: 0.6078431373, blue: 0.1411764706, alpha: 1)
        let color = UIColor.init(red:37/255.0, green:155/255.0, blue:36/255.0, alpha:1)
        return color
    }
    
    func greenTransColor() -> UIColor {
        _ = #colorLiteral(red: 0.1450980392, green: 0.6078431373, blue: 0.1411764706, alpha: 0.5)
        let color = UIColor.init(red:37/255.0, green:155/255.0, blue:36/255.0, alpha:0.8)
        return color
    }
    
    func redColor() -> UIColor {
        _ = #colorLiteral(red: 0.8980392157, green: 0.1098039216, blue: 0.137254902, alpha: 1)
        let color = UIColor.init(red:229.0/255.0, green:28.0/255.0, blue:35.0/255.0, alpha:1)
        return color
    }
    
    func redTransColor() -> UIColor {
        _ = #colorLiteral(red: 0.8980392157, green: 0.1098039216, blue: 0.137254902, alpha: 0.5)
        let color = UIColor.init(red:229.0/255.0, green:28.0/255.0, blue:35.0/255.0, alpha:0.8)
        return color
    }
    
    func bglColor() -> UIColor {
        _ = #colorLiteral(red: 0.2078431373, green: 0.8549019608, blue: 0.7254901961, alpha: 0.5)
        let color = UIColor.init(red:53.0/255.0, green:218.0/255.0, blue:185.0/255.0, alpha:0.8)
        return color
    }
}
