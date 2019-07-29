//
//  CurrencyManager.swift
//  Landmark
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

///This acts as the ViewModel class which handles all the currency logic

enum CurrencyType: Int {
    case INR = 0
    case AED
    case SAR
}

protocol DisplayablePrice {
    var displayString: String { get }
    
    //func setDisplayString() -> String 
}

//extension DisplayablePrice {
//    func setDisplayString() -> String {
//        return "Currency Price"
//    }
//}

class CurrencyManager {
    var originalCurrency: Currency
    var convertedCurrecy: Currency
    
    init(dictionary: [String: Any]) {
        self.originalCurrency = Currency.init(dictionary: dictionary)
        self.convertedCurrecy = self.originalCurrency
        
        NotificationCenter.default.addObserver(self, selector: #selector(convertToSelectedCurrency(_:)), name: Notification.Name.CurrencyChanged, object: nil)
    }
    
    @objc private func convertToSelectedCurrency(_ notification: Notification) {
        let selectedCurrency = notification.object as! String
        let currentCurrency = self.convertedCurrecy.currency
        
        //handle conversion logic
        //however the conversion rate(SAR to INR) from response seems to have wrong value i.e the ratios are not right among all 3 currencies. Hence the values on UI might not be as correct as it should be
        if let conversionMap = CurrencyHandler.sharedInstance.conversionMap {
            for item in conversionMap {
                if item.from == currentCurrency && item.to == selectedCurrency {
                    self.convertedCurrecy.price = self.convertedCurrecy.price * item.rate
                    self.convertedCurrecy.currency = selectedCurrency
                    self.convertedCurrecy.displayString = "\(String(describing: self.convertedCurrecy.currency)) \(String(format: "%.2f", self.convertedCurrecy.price))"
                    break
                }
                if item.from == selectedCurrency && item.to == currentCurrency {
                    self.convertedCurrecy.price = self.convertedCurrecy.price / item.rate
                    self.convertedCurrecy.currency = selectedCurrency
                    self.convertedCurrecy.displayString = "\(String(describing: self.convertedCurrecy.currency)) \(String(format: "%.2f", self.convertedCurrecy.price))"
                    break
                }
            }
        }
        
        //        conversionMap?.forEach({ if $0.from == currentCurrency && $0.to == selectedCurrency {
        //            self.convertedCurrecy?.price = self.originalCurrency.price * $0.rate
        //            }})
    }
}

