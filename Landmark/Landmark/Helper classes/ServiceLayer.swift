//
//  ServiceLayer.swift
//  Landmark
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

//This is the service/network class(call it utility)

//handle all service response scenarios
enum RequestableResult<T> {
    
    case result(T)
    case error(Any?)
    case partial(data:T?, chunkId: Any)
    case notsupported
    case timeout
    case dataNotFound
    
    //return value associated with each success cases
    public var value: T? {
        switch self {
        case .result(let value):
            return value
        case .partial(data: let value, chunkId: _):
            return value
        default:
            return nil
        }
    }
    
    //bool to say if the response has any result associated with it
    public var hasResult: Bool {
        switch self {
        case .result, .partial:
            return true
        default:
            return false
        }
    }
    
    //bool to say if the response was any of the error cases
    public var hasError: Bool {
        switch self {
        case .error, .notsupported, .timeout, .dataNotFound:
            return true
        default:
            return false
        }
    }
    
}

class ServiceLayer {
    //added this since i am not able to hit this service from my work machine due to security policies
    //set this value to true to read from local .json file
    var isMock = true
    
    //dataRequest which sends request to given URL and retrieves response in the form of a RequestableResult object
    public func dataRequestWith(url: String, completion: @escaping (RequestableResult<Any?>) -> Void) {
        if isMock {
            self.mockRequestWithURL(url: url, completion: completion)
        } else {
            self.serviceRequestWithURL(url: url, completion: completion)
        }
    }
}

extension ServiceLayer {
    
    //read json response from the local "response.json" file
    func mockRequestWithURL(url: String, completion: @escaping (RequestableResult<Any?>) -> Void) {
        if let path = Bundle.main.path(forResource: "response", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let json = jsonResult as? Dictionary<String, AnyObject> {
                    //return json
                    completion(RequestableResult.result(json))
                }
            } catch let error {
                // handle error
                completion(RequestableResult.error(error))
            }
        }
    }
    
    //make a service call
    func serviceRequestWithURL(url: String, completion: @escaping (RequestableResult<Any?>) -> Void) {
        guard let dataURL = URL(string: url) else {
            return
        }
        //create shared singleton session object as we dont need to set any cache/cookie policies
        let session = URLSession.shared
        //create URLRequest object with default cache policy and a 60 seconds
        let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: CONSTANTS_STRUCT.TIMEOUT_INTERVAL)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(RequestableResult.error(error))
                return
            }
            
            guard let data = data else {
                completion(RequestableResult.dataNotFound)
                return
            }
            
            guard let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8) else {
                print("could not convert data to UTF-8 format")
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: utf8Data, options: .mutableContainers) as? [String: Any] {
                    completion(RequestableResult.result(json))
                }
            } catch let error {
                print(error.localizedDescription)
                completion(RequestableResult.error(error))
            }
        })
        task.resume()
    }
    
}
