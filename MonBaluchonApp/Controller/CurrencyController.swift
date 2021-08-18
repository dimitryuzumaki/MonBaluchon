//
//  CurrencyController.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation
import UIKit

class CurrencyVIewController: UIViewController {
    @IBOutlet weak var DollarsCurrency: UILabel!
    @IBOutlet weak var EurosMoney: UITextField!
    
    
    let service = CurrencyService()
    var rate: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        service.getRate { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rate):
                    self.rate = rate
                    case .failure:
                    self.errorInExchange()
                }
            }
            
        }
    }
    @IBAction func convert() {
        if let numberEuros = Double(self.EurosMoney.text!) {
            self.DollarsCurrency.text = String(numberEuros * rate!)
        }
    }
    @objc
    private func dismissKeyboard() {
        EurosMoney.resignFirstResponder()
    }
    func errorInExchange(){
        let alert = UIAlertController(title: "conversion impossible", message: "entrée une nouvelle conversion", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


