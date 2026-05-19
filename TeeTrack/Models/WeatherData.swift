//
//  WeatherData.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let sys: Sys // ✅ Add this

    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }

    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }

    struct Sys: Codable {
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }
}
