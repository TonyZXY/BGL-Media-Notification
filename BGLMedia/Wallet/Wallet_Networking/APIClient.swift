//
//  APIClient.swift
//  ApiWrapperTest
//
//  Created by yanshi on 23/4/18.
//  Modified from James Rochabrun's ProtocolBasedNetworkingTutorialFinal project
//  Copyright © 2018 yan. All rights reserved.
//

import Foundation

// generic APi client able to handle different types of Decodable data
protocol APIClient {
    var session: URLSession { get }
    
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
}

extension APIClient{
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    // params @completionHandler: pass result data or error to "result callback" function
    func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        // initialize dataTask and pass handle response data and errors to completion handler(@escaping)
        let task = session.dataTask(with: request) { data, response, error in
            // response validation
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }// check response code if request successful
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        // parse result json data to related data type
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    // perform request and fetch result data with customise decoding closure and completion handler
    // param decode: provide target type to decode and decode result type check
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
        // invoke decoding task, get dataTask and perform JSONTaskCompletionHandler
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in

            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        // perform request
        task.resume()
    }
    
    
    
}
