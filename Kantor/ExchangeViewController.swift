//
//  FirstViewController.swift
//  Kantor
//
//  Created by Marcin Pietrzak on 07.08.2017.
//  Copyright © 2017 Marcin Pietrzak. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userAmountTextField: UITextField!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet var hideUserInputsButton: UIBarButtonItem!
    @IBOutlet weak var currenciesPickerView: UIPickerView!
    
    var result: (buy: Float, sell: Float) = (0.0,0.0)
    
    var kantor = Kantor()
    var selectedCurrencyCode: String?
    
//  MARK: ViewController -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAmountTextField.text = "100"
        
        actionExchange()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(ExchangeViewController.actionHideUserInputs(_:)))
        self.view.addGestureRecognizer(tapGest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//  MARK: My Methods -
    
    func actionExchange() {
        let amount = Float(Int(userAmountTextField.text!)!)
        
        if let code = selectedCurrencyCode {
            result = kantor.exchange(amount: amount, currencyCode: code)
        } else {
            var allCodes = [String](kantor.currencies.keys)
            
            if (allCodes.count > 0) {
                var code = allCodes[0]
                result = kantor.exchange(amount: amount, currencyCode: code)
            }
            
        }
        
        actionUpdateInterface()

    }
    
    @IBAction func actionUpdateInterface() {
        var displayResult: Float = 0.0
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            displayResult = result.sell
        } else {
            displayResult = result.buy
        }
        
        exchangeLabel.text = "\(displayResult)"
    }
    
    @IBAction func actionUserAmountChanged(_ sender: Any) {
        
        actionExchange()
    }

    @IBAction func actionHideUserInputs(_ sender: Any) {
        userAmountTextField.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
//  MARK: UITextFieldDelegate Methods -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = hideUserInputsButton
    }
    
//  MARK: UIPickerViewMethods - 
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kantor.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var allCodes = [String](kantor.currencies.keys)
        var code = allCodes[row]
        
        if let currency = kantor.currencies[code] {
            return "\(currency.name) (\(currency.code))"
        }
        
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var allCodes = [String](kantor.currencies.keys)
        
        selectedCurrencyCode = allCodes[row]
        
        if let code = selectedCurrencyCode {
            currencyButton.setTitle(code, for: .normal)
            
            actionExchange()
        }
    }

}

