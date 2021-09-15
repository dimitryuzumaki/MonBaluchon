//
//  OpenWeatherMap.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

// MARK: - Properties

struct OpenWeatherMap: Codable {
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let sys: Sys
    let weather: [Weather]
    let main: Main
}


// MARK: - Main
struct Main: Codable {
    let temp: Double
}

// MARK: - Sys
struct Sys: Codable {
    let country: String
}

// MARK: - Weather
struct Weather: Codable {
    let  weatherDescription: String
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        
    }
}
