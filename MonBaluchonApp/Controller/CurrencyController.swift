//
//  CurrencyController.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import UIKit
import Network

class CurrencyVIewController: UIViewController {
    @IBOutlet weak var DollarsCurrency: UILabel!
    @IBOutlet weak var EurosMoney: UITextField!
    
    // MARK: - Properties
    let service = CurrencyService()
    var rate: Double?
    var isConnectionOK: Bool = true
    private var monitor = NWPathMonitor()
    
    
    
    // MARK: - Main Queue
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(dismissKeyboard)))
        
        service.getRate { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let rate):
                self.rate = rate
                print(rate)
            case .failure(let error):
                print (error)
            }
        }
    }
    // MARK: - Button for convert the euros to dollars
    @IBAction func convert() {
        guard let rate = rate else {return}
        if let text = self.EurosMoney.text,
           let euroValue = Double(text) {
            print(euroValue)
            self.DollarsCurrency.text = "\(euroValue * rate)"
        } else {
            self.showAlert(title: "conversion impossible", message: "entrée une nouvelle conversion")
        }
    }
    
    // MARK: - Function to remove the keyboard
    @objc private func dismissKeyboard() {
        EurosMoney.resignFirstResponder()
    }
    // MARK: - Function For Connection Alert
    func noConnection(){
        if isConnectionOK {
            monitor.start(queue: DispatchQueue.global(qos: .background))
            monitor.pathUpdateHandler = {
                path in self .isConnectionOK = path.status == .satisfied
            }
        } else {
            self.showAlert(title: "Aucune connexion", message: "réesayer")
        }
        
        
    }
}
