//
//  TranslateService.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

import Foundation

final class TranslateService {
    
    private let session : URLSession
    private var task : URLSessionDataTask?
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getTranslation(text: String, callback: @escaping (Result<String,NetworkError>)-> Void) {
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "https://www.googleapis.com/language/translate/v2?key=AIzaSyCloEtJkAJnK4FLAnD5t4clDKnvGRqYB4I&target=en&format=text&q=\(encodedText)") else {
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
            
            guard let jsonDecoded = try? JSONDecoder().decode(GoogleTranslate.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(jsonDecoded.data.translations[0].translatedText))
            
        })
        task?.resume()
    }
    
}

