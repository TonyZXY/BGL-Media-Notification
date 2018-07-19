//
//  Extension.swift
//  BGLMedia
//
//  Created by Bruce Feng on 6/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class Extension:NSObject{
    static let method = Extension()
    
    //Convert String to Date
    func convertStringToDate(date:String) -> Date{
//        let dateFormat1 = "yyyy-MM-dd"
        let dateFormat2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat2
        let newDate:Date = dateFormatter.date(from: date) ?? Date()
        return newDate
    }
    
    /// Convert Date to String
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = dateFormat2
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    
    func checkUsernameAndPassword(username: String, password: String) -> (String?, Bool) {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if emailPredicate.evaluate(with: username){
            let passwordFormat = "^((?!.*[\\s])(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$&*])(?=.*\\d).{8,15})$"
            let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
            if passwordPredicate.evaluate(with: password){
                return (nil,true)
            }else{
                return ("Wrong password format", false)
            }
        } else{
            return ("Wrong email format", false)
        }
    }
    
    
    func scientificMethod(number:Double)->String{
        var value:String = ""
        var getNumber:String =  String(number)
        
        if number == 0.0{
            value = "--"
        } else{
            if getNumber.prefix(1) != "-" {
                getNumber = "+" + getNumber
            }
            
            if getNumber[getNumber.index(getNumber.startIndex, offsetBy: 2)] == "."{
                if getNumber[getNumber.index(getNumber.startIndex, offsetBy: 1)] == "0"{
//                   value = String(format:"%.6f",number)
                    value = String(format:"%.3f",number)
                } else{
                    value = String(format:"%.2f",number)
                }
            } else{
                value = String(format:"%.2f",number)
            }
        }
        return value
    }
}

extension UIViewController{
    func checkDataRiseFallColor(risefallnumber: Double,label:UILabel,type:String) {
        //        let currecyLogo = ["AUD":"A$","JPY":"JP¥","USD":"$","CNY":"RMB¥","EUR":"€"]
        
        if type == "Default"{
            label.textColor = UIColor.white
            label.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number: risefallnumber)
        } else {
            if String(risefallnumber).prefix(1) == "-" {
                // lost with red
                label.textColor = ThemeColor().redColor()
                if type == "Percent"{
                    label.text = Extension.method.scientificMethod(number: risefallnumber) + "%"
                } else if type == "PercentDown"{
                    label.text =  "▼ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
                } else{
                    label.text = "▼ " + currecyLogo[priceType]! + Extension.method.scientificMethod(number: risefallnumber)
                }
            } else if String(risefallnumber) == "0.0"{
                // Not any change with white
                label.text = "--"
                label.textColor = UIColor.white
            } else {
                //Profit with green
                label.textColor = ThemeColor().greenColor()
                if type == "Percent"{
                    label.text =  Extension.method.scientificMethod(number: risefallnumber) + "%"
                } else if type == "PercentDown"{
                    label.text =  "▲ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
                } else{
                    label.text = "▲ " + currecyLogo[priceType]! + Extension.method.scientificMethod(number: risefallnumber)
                }
            }
        }
    }
}

class InsetLabel: UILabel {
    let topInset = CGFloat(0)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(20)
    let rightInset = CGFloat(20)
    
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    
    override open var intrinsicContentSize: CGSize {
        get{
            if self.text != ""{
                var intrinsicSuperViewContentSize = super.intrinsicContentSize
                intrinsicSuperViewContentSize.height += topInset + bottomInset
                intrinsicSuperViewContentSize.width += leftInset + rightInset
                return intrinsicSuperViewContentSize
            } else{
                return super.intrinsicContentSize
            }
        }
    }
}
