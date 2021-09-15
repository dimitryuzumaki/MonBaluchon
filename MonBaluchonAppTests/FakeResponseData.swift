//
//  FakeResponseData.swift
//  MonBaluchonAppTests
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

class FakeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKO = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    class NetworkError: Error {}
    static let error = NetworkError()
    
    static var exchengeCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        print(bundle)
        let url = bundle.url(forResource: "fixer", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var translationCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        print(bundle)
        let url = bundle.url(forResource: "googletranslate", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        print(bundle)
        let url = bundle.url(forResource: "openweathermap", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!
}

