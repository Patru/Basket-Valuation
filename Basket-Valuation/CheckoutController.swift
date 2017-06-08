//
//  CheckoutController.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 02.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import UIKit

class CheckoutController: UIViewController {
    var _basket = Basket()
    var basket : Basket { get { return _basket }
        set {
            _basket = newValue
            syncUI()
        }
    }
    private var _converter: CurrencyConverter = InitializingConverter()
    var converter: CurrencyConverter {
        get { return _converter }
        set {
            _converter = newValue
            availableCurrencies = _converter.availableCurrencies
            currencyPicker.reloadAllComponents()
        }
    }
    @IBOutlet weak var summaryField: UITextView!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var convertedLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    var availableCurrencies : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        syncUI()
        fetchRates()
    }
    let APIKey = "6e3740b43f3d4ea7bd49f672ac91401e"
    
    func fetchRates() {
        var urlComponents = URLComponents(string: "http://apilayer.net")!
        urlComponents.path = "/api/live"
        let apiKey = URLQueryItem(name: "access_key", value: APIKey)
        urlComponents.queryItems = [apiKey]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            if err == nil && response?.mimeType == "application/json" {
                DispatchQueue.main.async {
                    self.installPicker(rates: data!)
                }
            } else {
                DispatchQueue.main.async {
                    self.rateLabel.text = "no rates available"
                }
            }
            }.resume()
    }
    
    func installPicker(rates json:Data) {
        converter = JSONCurrencyConverter(data: json)
        if let usdRow = availableCurrencies.index(of: "USD") {
            currencyPicker.selectRow(usdRow, inComponent: 0, animated: false)
            syncUI()
        } else {
            print( "usd not found")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func syncUI() {
        if summaryField != nil {
            summaryField.text = basket.summary
        }
        if dollarLabel != nil {
            dollarLabel.text = basket.dollarString
        }
        if convertedLabel != nil {
            let selRow = currencyPicker.selectedRow(inComponent: 0)
            let currency : String
            if selRow >= 0 && selRow < availableCurrencies.count {
                currency = availableCurrencies[selRow]
            } else {
                currency = ""
            }
            convertedLabel.text = converter.format(usd:basket.dollarValue, as: currency)
            rateLabel.text = converter.rateString(for: currency)
        }
    }
}

// these two are intrinsically linked in our context, only one extension
extension CheckoutController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableCurrencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableCurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        syncUI()
    }

}


