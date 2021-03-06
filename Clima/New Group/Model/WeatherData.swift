//
//  WeatherData.swift
//  Clima
//
//  Created by Justyna Kowalkowska on 05/05/2020.
//  Copyright © 2020 App Justyna Kowalkowska. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
