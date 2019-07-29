//
//  Model.swift
//  Landmark
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

///This is the Data Model class or an Entity class

struct Inventory {
    var title: String?
    var conversion: [Conversion] = []
    var product: [Product] = []
    
    init(dictionary: [String: Any]) {
        self.title = dictionary[IDENTIFIERS.INVENTORY_TITLE] as? String
        let jsonConversion = dictionary[IDENTIFIERS.CONVERSION] as! [Any]
        
        for conversion in jsonConversion {
            if let record = conversion as? [String: Any] {
                let conversionObject = Conversion.init(dictionary: record)
                    self.conversion.append(conversionObject)
            }
        }
        
        let jsonProducts = dictionary[IDENTIFIERS.PRODUCTS] as! [Any]
        
        for product in jsonProducts {
            if let record = product as? [String: Any] {
                let pdt = Product.init(dictionary: record)
                self.product.append(pdt)
            }
        }
    }
}


struct Conversion {
    var from: String!
    var to: String!
    var rate: Double!
    
    init(dictionary: [String: Any]) {
        self.from = dictionary[IDENTIFIERS.CONVERSION_FROM] as? String
        self.to = dictionary[IDENTIFIERS.CONVERSION_TO] as? String
        if let conversionRate = dictionary[IDENTIFIERS.CONVERSION_RATE] as? String {
            self.rate = Double(conversionRate)
        }
    }
}


struct Product {
    var url: String?
    var name: String?
    var currencyHolder: CurrencyManager!
    
    init(dictionary: [String: Any]) {
        self.url = dictionary[IDENTIFIERS.PRODUCT_URL] as? String ?? ""
        self.name = dictionary[IDENTIFIERS.PRODUCT_NAME] as? String ?? ""
        self.currencyHolder = CurrencyManager.init(dictionary: dictionary)
    }
}


struct Currency: DisplayablePrice {
    var displayString: String
    
    var price: Double = 0
    var currency: String
    
    init(dictionary: [String: Any]) {
        if let productPrice = dictionary[IDENTIFIERS.PRODUCT_PRICE] as? String {
            self.price = Double(productPrice) ?? 0
        }
        self.currency = dictionary[IDENTIFIERS.PRODUCT_CURRENCY] as? String ?? ""
        self.displayString = "\(String(describing: self.currency)) \(String(format: "%.2f", self.price))"
    }
}
