//
//  ViewController.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 02.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import UIKit

class BasketController: UIViewController {
    @IBOutlet weak var peasField: UITextField!
    @IBOutlet weak var eggsField: UITextField!
    @IBOutlet weak var milkField: UITextField!
    @IBOutlet weak var beansField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func basket() -> Basket {
        let peas = Int(peasField.text!) ?? 0
        let eggs = Int(eggsField.text!) ?? 0
        let milk = Int(milkField.text!) ?? 0
        let beans = Int(beansField.text!) ?? 0
        return Basket(peaBags: peas, eggDozens: eggs,
                      milkBottles: milk, beanCans: beans)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("Checkout"):
            if let checkout = segue.destination as? CheckoutController {
                checkout.basket = basket()
            }
        default: ()
        }
    }
    @IBAction func unwindToBasketController(segue: UIStoryboardSegue) {
    }

    @IBAction func endEditing(_ : UIButton) {
        view.endEditing(true)
    }
}

