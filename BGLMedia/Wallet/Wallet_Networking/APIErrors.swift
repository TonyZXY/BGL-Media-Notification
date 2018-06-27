//
//  APIErrors.swift
//  ApiWrapperTest
//
//  Created by yanshi on 23/4/18.
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
