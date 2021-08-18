//
//  WeatherService.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

final class WeatherService {
    
    private let session : URLSession
    private var task : URLSessionDataTask?
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getWeather(callback: @escaping (Result<[List],NetworkError>)-> Void){
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/group?id=5128638,2968815&units=metric&APPID=c7c391fd6f298f38c64cd083cded3382") else {
            return
        }
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
