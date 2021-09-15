//
//  TranslateController.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import UIKit
import Network
class TranslateViewController: UIViewController {
    
    
    @IBOutlet weak var langageTextView: UITextView!
    @IBOutlet weak var englishTextView: UITextView!
    
    // MARK: - Properties
    let service = TranslateService()
    var isConnectionOK: Bool = true
    private var monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    // MARK: - Main Queue and button to convert any language to English
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        guard let text = langageTextView.text else { return }
        service.getTranslation(text: text) { [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let translation):
                    self?.englishTextView.text = translation
                case .failure:
                    self?.showAlert(title: "traduction impossible", message: "entrée une phrase correcte")
                }
            }
        }
        
    }
    // MARK: - Func to remove the keyboard
    @objc
    private func dismissKeyboard() {
        langageTextView.resignFirstResponder()
    }
    // MARK: - Func for Connection Alert
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
