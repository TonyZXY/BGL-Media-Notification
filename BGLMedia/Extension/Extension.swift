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
    
}
