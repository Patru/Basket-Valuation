//
//  Basket.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 02.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import Foundation

struct Basket {
    var peaBags : Int = 0
    var eggDozens : Int = 0
    var milkBottles : Int = 0
    var beanCans : Int = 0
    
    public init(peaBags : Int = 0, eggDozens : Int = 0, milkBottles : Int = 0, beanCans : Int = 0) {
        self.peaBags = peaBags
        self.eggDozens = eggDozens
        self.milkBottles = milkBottles
        self.beanCans = beanCans
    }

    
    var summary : String { get {
        if empty {
            return "Your basket is empty"
        } else {
            var summ = "Your basket contains the following items:"
            if peaBags > 0 {
                summ += "\n\(peaBags) bags of peas"
            }
            if eggDozens > 0 {
                summ += "\n\(eggDozens) dozen eggs"
            }
            if milkBottles > 0 {
                summ += "\n\(milkBottles) bottles of milk"
            }
            if beanCans > 0 {
                summ += "\n\(beanCans) cans of beans"
            }
            return summ
        }
        }
    }
    var empty : Bool { get {
        return peaBags <= 0 && eggDozens <= 0 && milkBottles <= 0 && beanCans <= 0
        }
    }
    
    var dollarValue : Double {
        return Double(peaBags)*0.95 + Double(eggDozens)*2.1 + Double(milkBottles)*1.3 + Double(beanCans) * 0.73
    }
    
    var dollarString : String {
        return String(format:"$ %.2f", dollarValue)
    }
}
