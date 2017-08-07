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
    @IBOutlet weak var hideUserInputsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAmountTextField.text = "100"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionHideUserInputs(_ sender: Any) {
        userAmountTextField.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem = hideUserInputsButton
    }
    

}

