//
//  TranslateService.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

final class TranslateService {
    
    // MARK: - Properties
    private let session : URLSession
    private var task : URLSessionDataTask?
    
    // MARK: - Initializer
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    // MARK: - CallBack
    func getTranslation(text: String,
                        callback: @escaping (Result<String,NetworkError>)-> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "format", value: "text"),
            URLQueryItem(name: "source", value: text),
            URLQueryItem(name: "target", value: "en"),
            URLQueryItem(name: "key", value: "AIzaSyCloEtJkAJnK4FLAnD5t4clDKnvGRqYB4I")
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
            guard let jsonDecoded = try? JSONDecoder().decode(GoogleTranslate.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(jsonDecoded.data.translations[0].translatedText))
        })
        task?.resume()
    }
    
}

