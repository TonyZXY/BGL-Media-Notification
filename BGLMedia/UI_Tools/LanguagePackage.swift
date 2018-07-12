//
//  LanguagePackage.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 12/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import Foundation
import UIKit

var defaultLanguage:String {
    get{
        var language:String = ""
        if let defaultCurrency = UserDefaults.standard.value(forKey: "defaultLanguage") as? String{
            language = defaultCurrency
            return language
        } else {
            return language
        }
    }
}


extension UIViewController{
    func textValue(name:String)->String{
        var bundals = Bundle()
        if defaultLanguage == "EN"{
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            bundals = Bundle.init(path: path!)!
            
        } else if defaultLanguage == "CN"{
            let path = Bundle.main.path(forResource: "zh-Hans-CN", ofType: "lproj")
            bundals = Bundle.init(path: path!)!
        }
        return bundals.localizedString(forKey:name,value:nil,table:nil)
    }
}

extension UIView{
    func textValue(name:String)->String{
        var bundals = Bundle()
        if defaultLanguage == "EN"{
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            bundals = Bundle.init(path: path!)!

        } else if defaultLanguage == "CN"{
            let path = Bundle.main.path(forResource: "zh-Hans-CN", ofType: "lproj")
            bundals = Bundle.init(path: path!)!
        }
        return bundals.localizedString(forKey:name,value:nil,table:nil)
    }
}
