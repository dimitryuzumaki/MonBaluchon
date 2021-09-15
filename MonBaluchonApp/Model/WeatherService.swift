//
//  WeatherService.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

final class WeatherService {
    // MARK: - Properties
    
    private let session : URLSession
    private var task : URLSessionDataTask?
    
    // MARK: - Initializer
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // MARK: - Callback
    
    func getWeather(callback: @escaping (Result<[List],NetworkError>)-> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/group"
        urlComponents.queryItems = [
            URLQueryItem(name: "id", value: "5128638,2968815"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "appid", value: "c7c391fd6f298f38c64cd083cded3382")
        ]
        guard let url = urlComponents.url else {return}
        task?.cancel()
        task = session.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                callback(.failure(.noData))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                callback(.failure(.badResponse))
                return
            }
            
            guard let jsonDecoded = try? JSONDecoder().decode(OpenWeatherMap.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(jsonDecoded.list))
            
        })
        task?.resume()
        
    }
}
