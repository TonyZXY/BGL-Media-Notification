//
//  File.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Logo {
    let name: String
    let url: String
    
    init(_ json: JSON) {
        name = json["name"].stringValue
        url = json["logoURL"].stringValue
    }
}
