//
//  ForecastResponse.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [ForecastEntry]
}

struct ForecastEntry: Codable {
    let dt: TimeInterval
    let main: WeatherData.Main
    let weather: [WeatherData.Weather]
    let wind: WeatherData.Wind
}


struct ForecastItem: Identifiable {
    var id = UUID()
    let fullDate: Date
    let time: String
    let temp: Int
    let iconCode: String
    let windSpeed: Double
    let humidity: Int

    init(from entry: ForecastEntry) {
        let date = Date(timeIntervalSince1970: entry.dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.time = formatter.string(from: date)
        self.fullDate = date
        self.temp = Int(entry.main.temp)
        self.iconCode = entry.weather.first?.icon ?? "01d"
        self.windSpeed = entry.wind.speed
        self.humidity = entry.main.humidity
    }
}


