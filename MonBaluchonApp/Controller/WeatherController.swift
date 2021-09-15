//
//  WeatherController.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import UIKit
import Network

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var newYorkDescription: UILabel!
    @IBOutlet weak var newYorkTemp: UILabel!
    @IBOutlet weak var parisDescription: UILabel!
    @IBOutlet weak var parisTemp: UILabel!
    // MARK: - Properties
    let service = WeatherService()
    var isConnectionOK: Bool = true
    private var monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Main Queue and meteorological data
        service.getWeather { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.newYorkTemp.text = String(weather[0].main.temp) + "°C"
                    self.newYorkDescription.text = weather[0].weather[0].weatherDescription
                    self.parisTemp.text = String(weather[1].main.temp) + "°C"
                    self.parisDescription.text = weather[1].weather[0].weatherDescription
                case .failure:
                    self.showAlert(title: "Aucune données météo", message: "réessayer")
                }
            }
        }
    }
    // MARK: - Function for Connection Alert
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




