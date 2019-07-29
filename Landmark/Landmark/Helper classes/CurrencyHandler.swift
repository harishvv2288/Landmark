//
//  CurrencyHandler.swift
//  Landmark
//
//  Created by Harish V V on 28/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

extension Notification.Name { 
    static let CurrencyChanged = Notification.Name("CurrencyChanged")
}

class CurrencyHandler {
    
    static let sharedInstance = CurrencyHandler()
    
    //holds the currently selected currency from the segment control
    var currentCurrency: String?
    
    //holds the conversion map from response to be availabvle at global scope
    var conversionMap: [Conversion]?
    
    private init() {}
    
    func updateCurrency(currency:String) {
        self.currentCurrency = currency
        NotificationCenter.default.post(name: Notification.Name.CurrencyChanged, object: self.currentCurrency)
    }
}
