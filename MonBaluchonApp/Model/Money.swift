//
//  Money.swift
//  MonBaluchonApp
//
//  Created by Dimitry Aumont on 17/08/2021.
//

import Foundation

// MARK: - Properties

struct Money: Decodable {
    let rates: [String: Double]
}

