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
    @IBOutlet weak var updatedDateLabel: UILabel!
    
    var result: (buy: Float, sell: Float) = (0.0,0.0)
    
    var kantor = Kantor()
    var selectedCurrencyCode: String?
    
//  MARK: ViewController -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var defaults = UserDefaults.standard
        selectedCurrencyCode = defaults.string(forKey: "selectedCurrencyCode")
        
        if let code = selectedCurrencyCode {
            currencyButton.setTitle(code, for: .normal)
        }
        
        userAmountTextField.text = "100"
        
        actionExchange()
        showUpdatedDate()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(ExchangeViewController.actionHideUserInputs(_:)))
        self.view.addGestureRecognizer(tapGest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//  MARK: My Methods -
    
    func showUpdatedDate() {
        var today = NSDate()
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        updatedDateLabel.text = dateFormatter.string(from: today as Date)
    }
    
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
        
        var number = NSNumber(value: displayResult)
        
        exchangeLabel.text = kantor.currencyFormatter.string(from: number)
    }
    
    @IBAction func actionUserAmountChanged(_ sender: Any) {
        
        actionExchange()
    }

    @IBAction func actionShowCurrenciesView(_ sender: Any) {
        currenciesPickerView.isHidden = false
        navigationItem.rightBarButtonItem = hideUserInputsButton
        
        if let code = selectedCurrencyCode {
            var allCodes = [String](kantor.currencies.keys)
            
            var row: Int?
            var index = 0
            
            for item in allCodes {
                if (item == code) {
                    row = index
                    break
                }
                
                index += index
            }
            
            
            if let currencyRow = row {
                currenciesPickerView.selectRow(currencyRow, inComponent: 0, animated: false)
            }
        }
        
        currenciesPickerView.selectRow(1, inComponent: 0, animated: false)
    }
    
    @IBAction func actionHideUserInputs(_ sender: Any) {
        userAmountTextField.resignFirstResponder()
        currenciesPickerView.isHidden = true
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
            
            var defaults = UserDefaults.standard
            defaults.set(code, forKey: "selectedCurrencyCode")
            defaults.synchronize()
            
            currencyButton.setTitle(code, for: .normal)
            
            actionExchange()
        }
    }

}

