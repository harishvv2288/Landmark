//
//  ProductManager.swift
//  Landmark
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

///This acts as the ViewModel class which handles all the product logic

//this enum would contain all the service calls triggered from the View's this ViewModel class associates with
enum ServiceType: String {
    case fetchProductList
}

class ProductManager {
    var serviceLayer: ServiceLayer?
    
    init() {
        self.serviceLayer = ServiceLayer()
    }
    
    public func triggerServiceCall(serviceType: ServiceType, completion: @escaping (RequestableResult<Any?>) -> Void) {
        let url = URL_STRINGS.PRODUCT_LIST
        self.serviceLayer?.dataRequestWith(url: url, completion: { (result) in
            if result.hasResult {
                if let value = result.value as? [String: Any] {
                    //create Inventory object from json
                    let modelObject = Inventory.init(dictionary: value)
                    completion(RequestableResult.result(modelObject))
                }
            }
        })
    }
}
