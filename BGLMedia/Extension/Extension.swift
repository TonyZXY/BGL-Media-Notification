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
    
    /// Convert Date to String
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let dateFormat2 = "yyyy-MM-dd  HH:mm:ss "
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
    
    func checkInputVaild(value:String)->Bool{
        let doubleFormat = "^(0|([1-9][0-9]*))(\\.[0-9]+)?$"
        let doublePredicate = NSPredicate(format:"SELF MATCHES %@", doubleFormat)
        if doublePredicate.evaluate(with: value){
            return true
        } else{
            return false
        }
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
    UserDefaults.standard.set("null", forKey: "CertificateToken")
    UserDefaults.standard.set("null", forKey: "UserToken")
    let realm = try! Realm()
    try! realm.write {
        realm.delete(realm.objects(alertObject.self))
        realm.delete(realm.objects(alertCoinNames.self))
    }
}


