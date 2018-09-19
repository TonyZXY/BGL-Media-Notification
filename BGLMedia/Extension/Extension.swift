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
import Kingfisher
import RealmSwift
import SwiftKeychainWrapper

class Extension:NSObject{
    var realm = try! Realm()
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
    
    func convertStringToDate2(date:String) -> String{
        //        let dateFormat1 = "yyyy-MM-dd"
        let dateFormat1 = "yyyy-MM-dd  HH:mm:ss "
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = dateFormat1
        let newDate:Date = dateFormatter1.date(from: date) ?? Date()
        
        let dateFormatter2 = DateFormatter()
         let dateFormat2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter2.dateFormat = dateFormat2
        let newDates: String = dateFormatter2.string(from: newDate)
        return newDates
    }
    
    
    
    func convertStringToDate3(date:String) -> String{
        let dateFormat1 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = dateFormat1
        let newDate:Date = dateFormatter1.date(from: date) ?? Date()
        
        let dateFormatter2 = DateFormatter()
        let dateFormat2 = "yyyy-MM-dd"
        dateFormatter2.dateFormat = dateFormat2
        let newDates: String = dateFormatter2.string(from: newDate)
        return newDates
    }
    
    func convertStringToDate4(date:String) -> String{
        let dateFormat1 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = dateFormat1
        let newDate:Date = dateFormatter1.date(from: date) ?? Date()
        
        let dateFormatter2 = DateFormatter()
        let dateFormat2 = "HH:mm:ss"
        dateFormatter2.dateFormat = dateFormat2
        let newDates: String = dateFormatter2.string(from: newDate)
        return newDates
    }
    
    func convertStringToDate5(date:String) -> Date{
        //        let dateFormat1 = "yyyy-MM-dd"
        let dateFormat1 = "yyyy-MM-dd  HH:mm:ss "
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = dateFormat1
        let newDate:Date = dateFormatter1.date(from: date) ?? Date()
        return newDate
    }
    
    func convertDateToString6(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = dateFormat2
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    func convertDateToString7(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = dateFormat2
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    func convertDateToString8(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "HH:mm:ss"
        dateFormatter.dateFormat = dateFormat2
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    
    /// Convert Date to String
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "yyyy-MM-dd  HH:mm:ss "
        dateFormatter.dateFormat = dateFormat2
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    func convertDateToStringPickerDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "yyyy-MM-dd"
        dateFormatter.dateFormat = dateFormat2
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    func convertStringToDatePickerDate(date: String) -> Date {
        let dateFormat2 = "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat2
        let newDate:Date = dateFormatter.date(from: date) ?? Date()
        return newDate
    }
    
    func convertTimeToStringPickerDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "HH:mm:ss"
        dateFormatter.dateFormat = dateFormat2
        let newDate: String = dateFormatter.string(from: date)
        return newDate
    }
    
    func convertStringToTimePickerDate(date: String) -> Date {
        let dateFormat2 = "HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat2
        let newDate:Date = dateFormatter.date(from: date) ?? Date()
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
//        var value:String = ""
        var getNumber:String = String(format:"%f",number)
        
        let formatValue = Extension.method.formatNumber(number)
        if formatValue == "nil"{
            //            if number == 0.0{
            //                value = "--"
            //            } else{
            if getNumber.prefix(1) != "-" {
                getNumber = "+" + getNumber
            }
            if getNumber.count > 3 {
                if getNumber[getNumber.index(getNumber.startIndex, offsetBy: 2)] == "."{
                    if getNumber[getNumber.index(getNumber.startIndex, offsetBy: 1)] == "0"{
                        for i in 3...getNumber.count-1{
                            if getNumber[getNumber.index(getNumber.startIndex, offsetBy: i)] != "0"{
                                //                                    //                                print(getNumber)
                                //                                    //                                print(String(format:"%." + String(i-1) + "f",number))
                                if getNumber.count-1 != i{
                                    if getNumber[getNumber.index(getNumber.startIndex, offsetBy: i+1)] != "0"{
                                        return String(format:"%." + String(i-1) + "f",number)
                                    } else{
                                        return String(format:"%." + String(i-2) + "f",number)
                                    }
                                } else{
                                    return String(format:"%." + String(i-2) + "f",number)
                                }
                            }
                        }
                    } else{
                        return String(format:"%.2f",number)
                    }
                } else{
                    return String(format:"%.1f",number)
                }
            }else{
                return String(format:"%.2f",number)
            }
            return String(format:"%.2f",number)
        } else{
            return formatValue
        }
    }
    
    func scientificMethodInLike(number: Int) -> String{
        
        var value = ""
        if defaultLanguage == "CN"{
            if number > 9999 {
                let left = Double(number) / 10000.00
                value = String(format:"%.1f",left) + "万"
            } else {
                return "\(number)"
            }
        } else {
            if number > 999 && number < 1000000{
                let left = Double(number) / 1000.00
                value = String(format:"%.1f",left) + "k"
            } else if number > 1000000 {
                let left = Double(number) / 1000.00
                value = String(format:"%.1f",left) + "m"
            } else {
                return "\(number)"
            }
        }
        return value
    }
    
    func doubleToInteger(data:Double)-> Int {
        let doubleToString = "\(data)"
        let stringToInteger = (doubleToString as NSString).integerValue
        
        return stringToInteger
    }
    
    func checkInputVaild(value:String)->Bool{
        let doubleFormat = "^(0|([1-9][0-9]*))(\\.[0-9]+)?$"
        let doublePredicate = NSPredicate(format:"SELF MATCHES %@", doubleFormat)
        if doublePredicate.evaluate(with: value){
            return true
        } else{
            return false
        }
    }
    
//    func getCurrencyType(type:String){
//        let logo = ["AUD":"A$","JPY":"¥","USD":"$","CNY":"¥","EUR":"€"]
//        if let logos = logo[type]{
//
//        }
//    }
    
    func convertTimetoLocalization2(convert date: String) -> Date{
        let dateFormat1 = "yyyy-MM-dd  HH:mm:ss "
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = dateFormat1
        let newDate1:Date = dateFormatter1.date(from: date) ?? Date()
//        let formatter = DateFormatter()
//        if defaultLanguage == "CN"{
//            formatter.locale = Locale(identifier: "zh")
//        }else{
//            formatter.locale = Locale(identifier: "en")
//        }
        return newDate1
        
        
//        let dateFormatter = DateFormatter()
//        let dateFormat2 = "yyyy-MM-dd  HH:mm:ss "
//        dateFormatter.dateFormat = dateFormat2
//        let newDate2: String = dateFormatter.string(from: newDate1)
//        return newDate2

        
    }
    
    func convertTimetoLocalization(convert date: String) -> String{
        let cnTimeArray = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        let enTimeArray = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        let locale = Locale.current
        let languageCode = locale.languageCode
        if (languageCode == "zh" && defaultLanguage == "CN") || (languageCode == "en" && defaultLanguage == "EN"){
            if languageCode == "zh" && defaultLanguage == "CN"{
                let dateArr = date.components(separatedBy: ",")
                let year = dateArr[1]
                let subDataArr = dateArr[0].components(separatedBy: "月")
                let monthCN = subDataArr[0]
                let dateToString = subDataArr[1]
                let timeCN = dateArr[2]
                return  year + "年" + monthCN + "月" + dateToString + "日，" + timeCN
            } else {
                let dateArr = date.components(separatedBy: ",")
                let year = dateArr[1]
                let subDataArr = dateArr[0].components(separatedBy: " ")
                let monthEN = subDataArr[0]
                let dateToString = subDataArr[1]
                let timeEN = dateArr[2]
                return  dateToString + " " + monthEN + ", " + year + ", " + timeEN
            }
        } else{
            if languageCode == "zh" && defaultLanguage == "EN"{
                let dateArr = date.components(separatedBy: ",")
                let year = dateArr[1]
                let subDataArr = dateArr[0].components(separatedBy: "月")
                let monthCN = subDataArr[0]
                let monthEN = enTimeArray[cnTimeArray.index(of: monthCN)!]
                let dateToString = subDataArr[1]
                let timeCN = dateArr[2]
                var timeEN = ""
                if String(timeCN.suffix(2)) == "上午"{
                    timeEN = timeCN.replacingOccurrences(of: "上午", with: "am")
                } else{
                    timeEN = timeCN.replacingOccurrences(of: "下午", with: "pm")
                }
                return  dateToString + " " + monthEN + ", " + year + ", " + timeEN
            } else if languageCode == "en" && defaultLanguage == "CN" {
                let dateArr = date.components(separatedBy: ",")
                let year = dateArr[1]
                let subDataArr = dateArr[0].components(separatedBy: " ")
                let monthEN = subDataArr[0]
                let monthCN = cnTimeArray[enTimeArray.index(of: monthEN)!]
                let dateToString = subDataArr[1]
                let timeEN = dateArr[2]
                var timeCN = ""
                if String(timeEN.suffix(2)) == "am"{
                    timeCN = timeEN.replacingOccurrences(of: "am", with: "上午")
                } else{
                    timeCN = timeEN.replacingOccurrences(of: "pm", with: "下午")
                }
                return  year + "年" + monthCN + "月" + dateToString + "日，" + timeCN
            } else{
                return date
            }
        }
    }
    
    
    func reloadNavigationBarBackButton(navigationBarItem:UINavigationItem){
        let backItem = UIBarButtonItem()
        backItem.title = textValue(name: "back_button")
        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
        navigationBarItem.backBarButtonItem = backItem
    }
    
//    func formatPoints(from: Double) -> String {
//
//        let number = from
//        let thousand = number / 1000
//        let million = number / 1000000
//        let billion = number / 1000000000
//        let ss =  String(format:"%.2f",billion)
//        print(ss)
//        print(billion)
//        if billion >= 1.0 {
//            return "\(round(billion*10)/10)B"
//        } else if million >= 1.0 {
//            return "\(round(million*10)/10)M"
//        }
////        else if thousand >= 1.0 {
////            return ("\(round(thousand*10/10))K")
////        }
//        else {
////            return "\(Int(number))"
//            return "nil"
//        }
//    }
    
    func formatNumber(_ n: Double) -> String {
        
        let num = abs(n)
        let sign = (n < 0) ? "-" : ""
        
        switch num {
            
        case 1_000_000_000_000_000...:
            var formatted = num / 1_000_000_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)P"
        
        case 1_000_000_000_000...:
            var formatted = num / 1_000_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)T"
            
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)B"
            
        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)M"
            
            //        case 1_000...:
            //            var formatted = num / 1_000
            //            formatted = formatted.truncate(places: 1)
            //            return "\(sign)\(formatted)K"
            
            //        case 0...:
            //            return "\(n)"
            
        default:
//                        return "\(sign)\(n)"
            return "nil"
        }
    }

    

}




extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension UIViewController{
    func checkDataRiseFallColors(risefallnumber: Double,label:UILabel,type:String) {
        let currecyLogo = ["AUD":"A$","JPY":"JP¥","USD":"$","CNY":"RMB¥","EUR":"€"]
        
        
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

func checkDataRiseFallColor(risefallnumber: Double,label:UILabel,currency:String,type:String) {
    let logo = ["AUD":"A$","JPY":"¥","USD":"$","CNY":"¥","EUR":"€"]
    
    
    switch type {
    case "Default":
        label.textColor = UIColor.white
        if risefallnumber == 0{
            label.text = "--"
            label.textColor = UIColor.white
        } else{
            if let logos = logo[currency]{
                label.text = logos + Extension.method.scientificMethod(number: risefallnumber)
            }else{
                label.text = Extension.method.scientificMethod(number: risefallnumber) + " " + currency
            }
        }
        
        
//        if let logos = logo[currency]{
//            label.text = logos + Extension.method.scientificMethod(number: risefallnumber)
//        }else if String(risefallnumber) == "0.0"{
//            label.text = "--"
//            label.textColor = UIColor.white
//        } else{
//            label.text = Extension.method.scientificMethod(number: risefallnumber) + " " + currency
//        }
        
        
    case "Percent":
        if risefallnumber == 0{
            label.text = "--"
            label.textColor = UIColor.white
        } else{
            if String(risefallnumber).prefix(1) == "-" {
                label.textColor = ThemeColor().redColor()
            }else{
                label.textColor = ThemeColor().greenColor()
            }
            label.text = Extension.method.scientificMethod(number: risefallnumber) + "%"
        }
        
        
//         if String(risefallnumber).prefix(1) == "-" {
//            label.textColor = ThemeColor().redColor()
//         }else if String(risefallnumber) == "0.0"{
//            label.text = "--"
//            label.textColor = UIColor.white
//         } else{
//            label.textColor = ThemeColor().greenColor()
//         }
//         label.text = Extension.method.scientificMethod(number: risefallnumber) + "%"
        
    case "PercentDown":
        if risefallnumber == 0{
            label.text = "--"
            label.textColor = UIColor.white
        } else{
            if String(risefallnumber).prefix(1) == "-" {
                label.textColor = ThemeColor().redColor()
                label.text =  "▼ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
            }else{
                label.textColor = ThemeColor().greenColor()
                label.text =  "▲ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
            }
        }
        
        
//        if String(risefallnumber).prefix(1) == "-" {
//            label.textColor = ThemeColor().redColor()
//            label.text =  "▼ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
//        } else if String(risefallnumber) == "0.0"{
//            label.text = "--"
//            label.textColor = UIColor.white
//        }else{
//            label.textColor = ThemeColor().greenColor()
//            label.text =  "▲ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
//        }
        
    case "Number":
        if risefallnumber == 0{
            label.text = "--"
            label.textColor = UIColor.white
        }else{
            if String(risefallnumber).prefix(1) == "-" {
                label.textColor = ThemeColor().redColor()
                if let logos = logo[currency]{
                    label.text = "▼ " + logos + Extension.method.scientificMethod(number: risefallnumber)
                } else{
                    label.text = "▼ " + Extension.method.scientificMethod(number: risefallnumber) + " " + currency
                }
            }else{
                label.textColor = ThemeColor().greenColor()
                if let logos = logo[currency]{
                    label.text = "▲ " + logos + Extension.method.scientificMethod(number: risefallnumber)
                } else{
                    label.text = "▲ "  + Extension.method.scientificMethod(number: risefallnumber) + " " + currency
                }
                
            }
        }
        
        
//        if String(risefallnumber).prefix(1) == "-" {
//            label.textColor = ThemeColor().redColor()
//            if let logos = logo[currency]{
//                label.text = "▼ " + logos + Extension.method.scientificMethod(number: risefallnumber)
//            } else{
//                label.text = "▼ " + Extension.method.scientificMethod(number: risefallnumber) + " " + currency
//            }
//        } else if String(risefallnumber) == "0.0"{
//            label.text = "--"
//            label.textColor = UIColor.white
//        }else{
//            label.textColor = ThemeColor().greenColor()
//            if let logos = logo[currency]{
//                label.text = "▲ " + logos + Extension.method.scientificMethod(number: risefallnumber)
//            } else{
//                label.text = "▲ "  + Extension.method.scientificMethod(number: risefallnumber) + " " + currency
//            }
//
//        }
        
    default:
        label.textColor = UIColor.white
        label.text = Extension.method.scientificMethod(number: risefallnumber)
    }
    
    
//    if type == "Default"{
//        label.textColor = UIColor.white
//        label.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number: risefallnumber)
//    } else {
//        if String(risefallnumber).prefix(1) == "-" {
//            // lost with red
//            label.textColor = ThemeColor().redColor()
//            if type == "Percent"{
//                label.text = Extension.method.scientificMethod(number: risefallnumber) + "%"
//            } else if type == "PercentDown"{
//                label.text =  "▼ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
//            } else{
//                label.text = "▼ " + currecyLogo[priceType]! + Extension.method.scientificMethod(number: risefallnumber)
//            }
//        } else if String(risefallnumber) == "0.0"{
//            // Not any change with white
//            label.text = "--"
//            label.textColor = UIColor.white
//        } else {
//            //Profit with green
//            label.textColor = ThemeColor().greenColor()
//            if type == "Percent"{
//                label.text =  Extension.method.scientificMethod(number: risefallnumber) + "%"
//            } else if type == "PercentDown"{
//                label.text =  "▲ " + Extension.method.scientificMethod(number: risefallnumber) + "%"
//            } else{
//                label.text = "▲ " + currecyLogo[priceType]! + Extension.method.scientificMethod(number: risefallnumber)
//            }
//        }
//    }
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

class InsetButton:UIButton{
    let topInset = CGFloat(0)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(20)
    let rightInset = CGFloat(20)
    
//    open var contentEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
}

extension UIViewController {
    func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

extension UIImage {
    func reSizeImage(reSize:CGSize) -> UIImage? {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage
    }
    
    func scaleImage(scaleSize:CGFloat) -> UIImage? {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

extension UIFont
{
    class func regularFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    class func boldFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    class func semiBoldFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    class func lightFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    class func ItalicFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Italic", size: size)!
    }
    class func MediumFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Medium", size: size)!
    }
    class func ThinFont(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Montserrat-Thin", size: size)!
    }
    class func CandaraBoldItalic(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Candara-Bold-Italic", size: size)!
    }
    class func CandaraBold(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Candara-Bold", size: size)!
    }
    class func CandaraItalic(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Candara-Italic", size: size)!
    }
    class func Candara(_ size: CGFloat) -> UIFont
    {
        return UIFont(name: "Candara", size: size)!
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        }
        else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        }
        else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        }
        else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        return "\(secondsAgo / week) weeks ago"
    }
}

extension UIScrollView{
    public func beginHeaderRefreshing(){
        let header = self.viewWithTag(PullToRefreshKitConst.headerTag) as? RefreshHeaderContainer
        header?.beginRefreshing()
    }
}



    public func addRefreshHeaser()->DefaultRefreshHeader{
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        return header
    }

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func safeArea() ->UILayoutGuide{
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide
        } else {
            return self.layoutMarginsGuide
        }
    }
    
    func equalToAllAnchors(top:NSLayoutYAxisAnchor,bottom:NSLayoutYAxisAnchor,leading:NSLayoutXAxisAnchor,trailing:NSLayoutXAxisAnchor){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: top).isActive = true
        bottomAnchor.constraint(equalTo: bottom).isActive = true
        leadingAnchor.constraint(equalTo: leading).isActive = true
        trailingAnchor.constraint(equalTo: trailing).isActive = true
    }
}

public extension UIViewController {
    func addChildViewController(childViewControllers:UIViewController,cell:UICollectionViewCell){
        addChildViewController(childViewControllers)
        cell.contentView.addSubview(childViewControllers.view)
        childViewControllers.view.frame = view.bounds
        childViewControllers.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewControllers.didMove(toParentViewController: self)

        //Constraints
        childViewControllers.view.translatesAutoresizingMaskIntoConstraints = false
        childViewControllers.view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        childViewControllers.view.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        childViewControllers.view.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        childViewControllers.view.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
    }
}

class IndicatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func setupView(){
        backgroundColor = UIColor.darkGray
        let indicator = UIActivityIndicatorView()
        indicator.center = self.center
        addSubview(indicator)
        indicator.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IndicatorView: Placeholder { /* Just leave it empty */}

extension UIImageView {
    func setImage(urlString: String) {
        self.kf.setImage(with: URL(string: urlString), placeholder: IndicatorView(frame: frame) as Placeholder)
        //        self.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "loading"))
    }
}

func deleteMemory(){
    UserDefaults.standard.set(false,forKey: "isLoggedIn")
    UserDefaults.standard.set(true, forKey: "flashSwitch")
    UserDefaults.standard.set(true, forKey: "priceSwitch")
    UserDefaults.standard.set(false, forKey: "SendDeviceToken")
    UserDefaults.standard.set(false, forKey: "getDeviceToken")
    UserDefaults.standard.set("null", forKey: "UserEmail")
    KeychainWrapper.standard.set("null", forKey: "Email")
    UserDefaults.standard.set("null", forKey: "CertificateToken")
    UserDefaults.standard.set("null", forKey: "UserToken")
    let realm = try! Realm()
    try! realm.write {
        realm.delete(realm.objects(Transactions.self))
        realm.delete(realm.objects(EachTransactions.self))
        realm.delete(realm.objects(EachCurrency.self))
        realm.delete(realm.objects(alertObject.self))
        realm.delete(realm.objects(alertCoinNames.self))
    }
}

extension UIButton{
    func loadingIndicator(_ show : Bool){
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func load(urlString: String) {
        // clear image
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url, completionHandler: {(data,res,err) in
                if err != nil{
                    print(err ?? "unknown error")
                    return
                }
                
                DispatchQueue.main.async(execute: { ()->Void in
                    self.image = UIImage(data: data!)
                })
            }).resume()
        }
    }
}
// copied from https://stackoverflow.com/questions/28079123/how-to-check-validity-of-url-in-swift
extension String {
    
    private func matches(pattern: String) -> Bool {
        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: [.caseInsensitive])
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }
    
    func isValidURL() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }
        
        let urlPattern = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp;%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp;%\\$#\\=~_\\-]+))*$"
        return self.matches(pattern: urlPattern)
    }
}













