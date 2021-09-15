//
//  CurrencyService.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

enum NetworkError: Error {
    
    case noData, badResponse, undecodableData
}


final class CurrencyService {
    
    // MARK: - Properties
    private let session: URLSession
    private var task: URLSessionDataTask?
    
    // MARK: - Initializer
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // MARK: - CallBack
    
    func getRate(callback: @escaping (Result<Double,NetworkError>) -> Void){
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/latest"
        urlComponents.queryItems = [
            
            URLQueryItem(name: "access_key", value: "e297fa3045dfcecd4bd53515d93316ec")
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
            
            guard let jsonDecoded = try? JSONDecoder().decode(Money.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            guard let rate = jsonDecoded.rates["USD"] else {return}
            callback(.success(rate))
        })
        task?.resume()
    }
    
}
