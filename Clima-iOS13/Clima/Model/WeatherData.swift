//
//  WeatherData.swift
//  Clima
//
//  Created by Vladimir Gorbunov on 9/30/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct Weatherdata: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

