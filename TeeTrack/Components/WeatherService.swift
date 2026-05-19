//
//  WeatherService.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import Foundation
import CoreLocation

class WeatherService {
    private let apiKey = "" // Replace with your key
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(for location: CLLocationCoordinate2D, completion: @escaping (WeatherData?) -> Void) {
        let urlString = "\(baseURL)?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded)
                    }
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil)
                }
            } else {
                print("API error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchWeather(for city: String, completion: @escaping (WeatherData?) -> Void) {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityQuery)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("Weather (city) error: \(error?.localizedDescription ?? "No data")")
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                print("Weather (city) decoding error: \(error)")
                completion(nil)
            }
        }.resume()
    }

    
    
    func fetchForecast(for location: CLLocationCoordinate2D, completion: @escaping ([ForecastItem]) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("Error: \(error?.localizedDescription ?? "No data")")
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.list.prefix(5).map { ForecastItem(from: $0) })
                }
            } catch {
                print("Forecast decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
    func fetchForecast(for city: String, completion: @escaping ([ForecastItem]) -> Void) {
        let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityQuery)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("Forecast (city) error: \(error?.localizedDescription ?? "No data")")
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.list.prefix(40).map { ForecastItem(from: $0) })
                }
            } catch {
                print("Forecast (city) decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
    
    



}
