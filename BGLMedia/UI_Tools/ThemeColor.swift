//
//  Color.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 27/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class ThemeColor:UIColor{
    
    
    func shareImageBackgroundColor() -> UIColor {
        _ = #colorLiteral(red: 0.1215686275, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
        let color = UIColor.init(red:40/255.0, green:98/255.0, blue:168/255.0, alpha:1)
        return color
    }
    
    func unrealisedPriceColor() -> UIColor {
        _ = #colorLiteral(red: 0.1215686275, green: 0.7450980392, blue: 0.7647058824, alpha: 1)
        let color = UIColor.init(red:31/255.0, green:190/255.0, blue:195/255.0, alpha:1)
        return color
    }
    
    func logoBackgroundColor() -> UIColor {
        _ = #colorLiteral(red: 0.1882352941, green: 0.3803921569, blue: 0.5764705882, alpha: 1)
        let color = UIColor.init(red:48/255.0, green:97/255.0, blue:147/255.0, alpha:1)
        return color
    }
    
    func systemBarButtonColor() -> UIColor {
        _ = #colorLiteral(red: 0.09803921569, green: 0.5019607843, blue: 0.9764705882, alpha: 1)
        let color = UIColor.init(red:25/255.0, green:128/255.0, blue:249/255.0, alpha:1)
        return color
    }
    
    func whiteColor() -> UIColor {
        _ = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let color = UIColor.white
        return color
    }
    
    func grayPlaceHolder() -> UIColor {
        _ = #colorLiteral(red: 0.937254902, green: 0.8986519431, blue: 0.8986519431, alpha: 1)
        let color = UIColor.init(red:205/255.0, green:205/255.0, blue:205/255.0, alpha:1)
        return color
    }
    
    func grayLightColor()-> UIColor {
        _ = #colorLiteral(red: 0.8992777034, green: 0.8992777034, blue: 0.8992777034, alpha: 1)
        let color = UIColor.init(red:229/255.0, green:229/255.0, blue:229/255.0, alpha:1)
        return color
    }
    
    func darkGreyColor() -> UIColor {
        _ = #colorLiteral(red: 0.1843137255, green: 0.1921568627, blue: 0.2117647059, alpha: 1)
        let color = UIColor.init(red:47/255.0, green:49/255.0, blue:54/255.0, alpha:1)
        return color
    }
    
    func darkBlackColor() -> UIColor {
        _ = #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.1450980392, alpha: 1)
        let color = UIColor.init(red:32/255.0, green:34/255.0, blue:37/255.0, alpha:1)
        return color
    }
    
    func greyColor() -> UIColor {
        _ = #colorLiteral(red: 0.2117647059, green: 0.2235294118, blue: 0.2431372549, alpha: 1)
        let color = UIColor.init(red:54/255.0, green:57/255.0, blue:62/255.0, alpha:1)
        return color
    }
    
    func textGreycolor() -> UIColor {
        _ = #colorLiteral(red: 0.2117647059, green: 0.2235294118, blue: 0.2431372549, alpha: 1)
        let color = UIColor.init(red:153/255.0, green:153/255.0, blue:153/255.0, alpha:1)
        return color
    }
    
    func greenColor() -> UIColor {
        _ = #colorLiteral(red: 0.1450980392, green: 0.6078431373, blue: 0.1411764706, alpha: 1)
        let color = UIColor.init(red:115/255.0, green:216/255.0, blue:109/255.0, alpha:1)
        return color
    }
    
    func redColor() -> UIColor {
        _ = #colorLiteral(red: 0.8980392157, green: 0.1098039216, blue: 0.137254902, alpha: 1)
        let color = UIColor.init(red:255.0/255.0, green:28.0/255.0, blue:35.0/255.0, alpha:1)
        return color
    }
    
    func redColorTran() -> UIColor {
        _ = #colorLiteral(red: 0.8980392157, green: 0.1098039216, blue: 0.137254902, alpha: 1)
        let color = UIColor.init(red:255.0/255.0, green:28.0/255.0, blue:35.0/255.0, alpha:0.2)
        return color
    }
    
    func blueColor() -> UIColor {
        _ = #colorLiteral(red: 0.2117647059, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
        let color = UIColor.init(red:54/255.0, green:221/255.0, blue:171/255.0, alpha:1)
        return color
    }
    
    func blueColorTran() -> UIColor {
        _ = #colorLiteral(red: 0.2117647059, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
        let color = UIColor.init(red:54/255.0, green:221/255.0, blue:171/255.0, alpha:0.5)
        return color
    }
    
    func progressColor() -> UIColor {
        _ = #colorLiteral(red: 0.7490196078, green: 0.7490196078, blue: 0.7490196078, alpha: 1)
        let color = UIColor.init(red:191/255.0, green:191/255.0, blue:191/255.0, alpha:0.5)
        return color
    }
    
    ///////////////
    
    func themeWidgetColor() -> UIColor{
        _ = #colorLiteral(red: 0.2117647059, green: 0.8666666667, blue: 0.6705882353, alpha: 1)
        let color = UIColor.init(red:54/255.0, green:221/255.0, blue:171/255.0, alpha:1)
        return color
    }
    
    func walletCellcolor() -> UIColor {
        _ = #colorLiteral(red: 0.2117647059, green: 0.2235294118, blue: 0.2431372549, alpha: 1)
        let color = UIColor.init(red:54/255.0, green:57/255.0, blue:62/255.0, alpha:1)
        return color
    }
    
    func navigationBarColor() -> UIColor {
        _ = #colorLiteral(red: 0.1254901961, green: 0.1333333333, blue: 0.1450980392, alpha: 1)
        let color = UIColor.init(red:32/255.0, green:34/255.0, blue:37/255.0, alpha:1)
        return color
    }
    
    func themeColor() -> UIColor {
        _ = #colorLiteral(red: 0.1843137255, green: 0.1921568627, blue: 0.2117647059, alpha: 1)
        let color = UIColor.init(red:47/255.0, green:49/255.0, blue:54/255.0, alpha:1)
        return color
    }
    
    
    
    
    
 //////////////////
//    func riseColor() -> UIColor {
//        _ = #colorLiteral(red: 0.1450980392, green: 0.6078431373, blue: 0.1411764706, alpha: 1)
//        let color = UIColor.init(red:115/255.0, green:216/255.0, blue:109/255.0, alpha:1)
//        return color
//    }
//
//    func fallColor() -> UIColor {
//        _ = #colorLiteral(red: 0.8980392157, green: 0.1098039216, blue: 0.137254902, alpha: 1)
//        let color = UIColor.init(red:229.0/255.0, green:28.0/255.0, blue:35.0/255.0, alpha:1)
//        return color
//    }
    
    
    
    

//    func greenTransColor() -> UIColor {
//        _ = #colorLiteral(red: 0.1450980392, green: 0.6078431373, blue: 0.1411764706, alpha: 0.5)
//        let color = UIColor.init(red:37/255.0, green:155/255.0, blue:36/255.0, alpha:0.8)
//        return color
//    }
    

//    func redTransColor() -> UIColor {
//        _ = #colorLiteral(red: 0.8980392157, green: 0.1098039216, blue: 0.137254902, alpha: 0.5)
//        let color = UIColor.init(red:229.0/255.0, green:28.0/255.0, blue:35.0/255.0, alpha:0.8)
//        return color
//    }
    
    func bglColor() -> UIColor {
        _ = #colorLiteral(red: 0.2078431373, green: 0.8549019608, blue: 0.7254901961, alpha: 0.5)
        let color = UIColor.init(red:53.0/255.0, green:218.0/255.0, blue:185.0/255.0, alpha:0.8)
        return color
    }
    
    func goldColor() -> UIColor {
        _ = #colorLiteral(red: 0.831372549, green: 0.8745098039, blue: 0, alpha: 1)
        let color =  UIColor.init(red:212.0/255.0, green:223.0/255.0, blue:0/255.0, alpha:1)
        return color
    }
    
    func silverColor() -> UIColor {
        _ = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        let color =  UIColor.init(red:192.0/255.0, green:192.0/255.0, blue:192.0/255.0, alpha:1)
        return color
    }
    
    func bronzeColor() -> UIColor {
        _ = #colorLiteral(red: 0.8039215686, green: 0.4980392157, blue: 0.1960784314, alpha: 1)
        let color =  UIColor.init(red:205.0/255.0, green:127.0/255.0, blue:50.0/255.0, alpha:1)
        return color
    }
}

//extension UIColor {
//    public convenience init?(hexString: String) {
//        let r, g, b, a: CGFloat
//        
//        if hexString.hasPrefix("#") {
//            let start = hexString.index(hexString.startIndex, offsetBy: 1)
//            let hexColor = String(hexString[start...])
//            
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//                
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//                    
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//        return nil
//    }
//    
//    // Using Method:   let gold = UIColor(hexString: "#ffe700ff")
//}
