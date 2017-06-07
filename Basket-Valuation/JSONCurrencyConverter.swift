//
//  JSONConverter.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 04.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import Foundation

class JSONCurrencyConverter : CurrencyConverter {
    private(set) var conversionRates = [String:Double]()
    private(set) var errorDescription = ""
    init(json: [String: Any]) {
        if let err = json["Error"] as? String {
            errorDescription = err
            return
        }
        guard let success = json["success"] as? Bool
            else {
                errorDescription = "success missing or not Bool"
                return
        }
        guard let quotes = json["quotes"] as? [String:Double]
            else {
                errorDescription = "quotes missing or not [String:Double]"
                return
        }

        if success {
            quotes.forEach { (conversion, rate) in
                let index = conversion.index(conversion.startIndex, offsetBy: 3)
                let target = conversion.substring(from: index)
                conversionRates[target] = rate
            }
        } else {
            errorDescription = "data request not successful"
        }
    }
    
    convenience init(data: Data) {
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.init(json: dict)
        } catch {
            self.init(json: ["Error": error.localizedDescription])
        }
    }
    convenience init(string: String) {
        if let validData = string.data(using: .utf8)
        {
            self.init(data: validData)
        } else {
            self.init(json: ["Error": "string value not encondeable in utf8"])
        }
    }
}
