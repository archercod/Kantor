//
//  FirstViewController.swift
//  Kantor
//
//  Created by Marcin Pietrzak on 07.08.2017.
//  Copyright © 2017 Marcin Pietrzak. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userAmountTextField: UITextField!
    @IBOutlet weak var exchangeLabel: UILabel!
    @IBOutlet weak var currencyButton: UIButton!
    @IBOutlet var hideUserInputsButton: UIBarButtonItem!
    
    var result: (buy: Float, sell: Float) = (0.0,0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAmountTextField.text = "100"
        
        actionUserAmountChanged(userAmountTextField)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(ExchangeViewController.actionHideUserInputs(_:)))
        self.view.addGestureRecognizer(tapGest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        result.buy = Float(Int(userAmountTextField.text!)! * 3)
        result.sell = Float(Int(userAmountTextField.text!)! * 4)
        
        actionUpdateInterface()
    }

    @IBAction func actionHideUserInputs(_ sender: Any) {
        userAmountTextField.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = hideUserInputsButton
    }
    

}

