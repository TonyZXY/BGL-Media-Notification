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

extension UIViewController{
    
    
    func passServerData(urlParameters:[String],httpMethod:String,parameters:[String:Any],completion:@escaping (JSON, Bool)->Void){
        var BaseURl = "http://10.10.6.18:3030"
        for path in urlParameters{
            BaseURl = BaseURl + "/" + path
        }
        let url = URL(string: BaseURl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = httpMethod
        
        if httpMethod == "POST"{
            let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = httpBody
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlRequest).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let res = JSON(value)
                print("get success")
                print(res)
                completion(res,true)
            case .failure(let error):
                print(error)
                 print("get faliure")
                completion(JSON(),false)
            }
        }
    }
}
