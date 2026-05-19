//
//  WeatherView.swift
//  TeeTrack
//
//  Created by Pierre Bastenier on 12/04/2025.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var customCity: String = ""
    @State private var recentCities: [String] = []
    @State private var weather: WeatherData?
    @State private var forecast: [ForecastItem] = []
    @State private var isLoading = false
    @State private var fetchError: Bool = false
    @State private var showWeatherData = false
    @State private var showForecast = false
    @State private var forceShowSpinner = false
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var selectedDate: Date? = nil
    @State private var availableDates: [Date] = []
    
    @State private var lastFetchedCity: String = ""

    
    private var currentIconCode: String {
        weather?.weather.first?.icon ?? "01d"
    }

    
    // 🧠 DATE FORMATTER
    let forecastDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd"
        return formatter
    }()
    
    
    
    let weatherService = WeatherService()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // ✅ Top bar
                BackTopBarView(title: "Weather") {
                    presentationMode.wrappedValue.dismiss()
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // ✅ City input
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Search by City")
                                .font(.headline)

                            HStack {
                                CustomTextField(placeholder: "Enter city golf course (e.g. Brussels)", text: $customCity)

                                Button(action: {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    fetchWeather(for: customCity)
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .padding(10)
                                        .foregroundColor(.white)
                                        .background(Color.primaryGreen)
                                        .clipShape(Circle())
                                }
                            }

                            // ✅ Recent cities
                            if !recentCities.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Recent Searches:")
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    HStack {
                                        ForEach(recentCities, id: \.self) { city in
                                            HStack(spacing: 4) {
                                                Button(action: {
                                                    customCity = city
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                    fetchWeather(for: city)
                                                }) {
                                                    Text("⛳️ \(city)")
                                                        .padding(.horizontal, 10)
                                                        .padding(.vertical, 6)
                                                        .background(Color.primaryGreen.opacity(0.1))
                                                        .foregroundColor(.primaryGreen)
                                                        .cornerRadius(10)
                                                }

                                                Button(action: {
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                    deleteCity(city)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                        }
                                    }

                                }
                            }
                        }
                        .padding(.horizontal)

                        Divider()

                        // ✅ States
                        if isLoading {
                            VStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .primaryGreen))
                                    .scaleEffect(1.5)
                                Text("Fetching weather...")
                                    .foregroundColor(.primaryGreen)
                                    .font(.subheadline)
                                    .padding(.horizontal)
                                    .padding(.top,30)
                            }
                            .padding()
                        } else if fetchError {
                            VStack {
                                Image(systemName: "wifi.slash")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("No internet connection or weather data available.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .padding(.top, 20)
                        } else if showWeatherData, let weather = weather {
                            
                            let iconCode = currentIconCode
                            let colors = iconColorStyle(for: iconCode)

                            VStack(spacing: 20) {
                                

                                VStack(spacing: 8) {
                                    Text("\(lastFetchedCity) – Now")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 10)
                                        .background(Color.primaryGreen)
                                        .clipShape(Capsule())

                                    Image(systemName: WeatherView.weatherIconName(for: iconCode))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .padding(.top, 2)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(colors.0, colors.1)
                                }


                                Text(weather.weather.first?.description.capitalized ?? "")
                                    .font(.headline)
                                    .foregroundColor(.gray)

                                Text("\(Int(weather.main.temp))°C")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.primaryGreen)

                                HStack(spacing: 30) {
                                    VStack {
                                        Image(systemName: "wind")
                                        Text("\(Int(weather.wind.speed)) km/h").foregroundColor(.primaryGreen)
                                        Text("Wind").font(.caption).foregroundColor(.primaryGreen)
                                    }

                                    VStack {
                                        Image(systemName: "humidity")
                                        Text("\(weather.main.humidity)%").foregroundColor(.primaryGreen)
                                        Text("Humidity").font(.caption).foregroundColor(.primaryGreen)
                                    }
                                }
                                .font(.subheadline)
                            }
                            
                            //.padding()
                            .transition(.opacity)
                        }

                        // ✅ Forecast
                        if showForecast, !forecast.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Upcoming Days")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                    .foregroundColor(.gray)

                                // Horizontal date selector
                               
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(availableDates, id: \.self) { date in
                                            Button(action: {
                                                selectedDate = date
                                            }) {
                                                Text(dayFormatter.string(from: date))
                                                    .fontWeight(.medium)
                                                    .foregroundColor(selectedDate == date ? .white : .primaryGreen)
                                                    .padding(.vertical, 6)
                                                    .padding(.horizontal, 12)
                                                    .background(selectedDate == date ? Color.primaryGreen : Color.primaryGreen.opacity(0.1))
                                                    .cornerRadius(10)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                  

                                Divider()
                                
                                let bestSlot = findBestGolfTime(in: filteredForecasts(for: selectedDate))
                               

                                ScrollViewReader { proxy in
                                    // Filtered forecast list
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            // let bestSlot = findBestGolfTime(in: forecast)
                                            let filtered = filteredForecasts(for: selectedDate)
                                            Color.clear
                                                .frame(width: 8) // Match horizontal padding
                                                .id("startAnchor")
                                            ForEach(filtered) { item in
                                                let isBest = isBestSlot(item, comparedTo: bestSlot)
                                                let forecastColors = iconColorStyle(for: item.iconCode)
                                                
                                                ForecastCardView(item: item, isBest: isBest, colors: forecastColors)
                                            }
                                        }
                                        .padding(.vertical,6)
                                        //.padding(.horizontal)
                                    }
                                    .onChange(of: selectedDate) { _ in
                                        if let firstItem = filteredForecasts(for: selectedDate).first {
                                            proxy.scrollTo("startAnchor", anchor: .leading)
                                        }
                                    }
                                }
                                    

                                Divider()
                                    
                                if let best = findBestGolfTime(in: filteredForecasts(for: selectedDate)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("🏌️ Best Time to Play on \(dayFormatter.string(from: selectedDate ?? Date()))")

                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryGreen)
                                        Text("\(best.timeFormatted) – \(best.temp)°C, \(best.condition)")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)
                                } else {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("🏌️ Best Time to Play on \(dayFormatter.string(from: selectedDate ?? Date()))")

                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primaryGreen)
                                        Text("No great weather slot coming up. Practice your putt instead 😉")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal)
                                }

                                
                            }
                            .padding(.top, 16)
                            .transition(.opacity)
                        }

                        Spacer(minLength: 60)
                    }
                    .padding(.top, 16)
                }
            }
        }

        .navigationBarHidden(true)
        .onAppear {
            loadRecentCities()
        }

    }

    // MARK: - Fetch

    func fetchWeather(for city: String) {
        guard !city.isEmpty else { return }
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("🚫 Empty city name.")
            self.customCity = ""
            return
        }

        isLoading = true
        fetchError = false
        weather = nil
        forecast = []
        showWeatherData = false
        showForecast = false
        forceShowSpinner = true

       
        weatherService.fetchWeather(for: city) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.weather = result
                self.isLoading = false
                self.forceShowSpinner = false

                if result == nil {
                    self.fetchError = true
                } else {
                    self.lastFetchedCity = city
                    self.customCity = ""

                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.showWeatherData = true
                        self.showForecast = true
                    }
                }
            }
        }


        weatherService.fetchForecast(for: city) { result in
            self.forecast = result

            if result.isEmpty {
                self.fetchError = true
            } else {
                let uniqueDates = Array(Set(result.map { Calendar.current.startOfDay(for: $0.fullDate) })).sorted()
                self.availableDates = uniqueDates

                let today = Calendar.current.startOfDay(for: Date())

                if uniqueDates.contains(today) {
                    self.selectedDate = today
                } else {
                    self.selectedDate = uniqueDates.first
                }

            }
        }



        addToRecentCities(city)
    }

    func addToRecentCities(_ city: String) {
        guard let email = authVM.currentUser?.email else { return }

        var updated = recentCities
        updated.removeAll(where: { $0.lowercased() == city.lowercased() })
        updated.insert(city, at: 0)

        if updated.count > 3 {
            updated = Array(updated.prefix(3))
        }

        recentCities = updated
        UserDefaults.standard.set(updated, forKey: userKey(for: email))
    }
    
    func loadRecentCities() {
        guard let email = authVM.currentUser?.email else { return }
        recentCities = UserDefaults.standard.stringArray(forKey: userKey(for: email)) ?? []
    }
    
    func deleteCity(_ city: String) {
        guard let email = authVM.currentUser?.email else { return }

        recentCities.removeAll(where: { $0 == city })
        UserDefaults.standard.set(recentCities, forKey: userKey(for: email))
    }



    // MARK: - Icons

    static func weatherIconName(for code: String) -> String {
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d", "02n": return "cloud.sun.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d", "10n": return "cloud.rain.fill"
        case "11d", "11n": return "cloud.bolt.fill"
        case "13d", "13n": return "cloud.snow.fill"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark.circle"
        }
    }

    struct ForecastCardView: View {
        let item: ForecastItem
        let isBest: Bool
        let colors: (Color, Color)

        var body: some View {
            VStack(spacing: 8) {
                Text(item.time)
                    .font(.caption)
                    .foregroundColor(.gray)

                Image(systemName: weatherIconName(for: item.iconCode))
                    .font(.title2)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(colors.0, colors.1)

                Text("\(item.temp)°C")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)

                if isBest {
                    Text("🏌️ Best")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.primaryGreen)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isBest ? Color.primaryGreen : Color.gray.opacity(0.25), lineWidth: 0.8)
            )
        }
    }

    
    func iconColorStyle(for code: String) -> (Color, Color) {
        switch code {
        case "01d": // Clear day
            return (.yellow, .orange)
        case "01n": // Clear night
            return (.gray.opacity(0.75), .gray.opacity(0.5))

        case "02d": // Few clouds day
            return (.gray, .yellow)
        case "02n": // Few clouds night
            return (.white, .gray)

        case "03d", "03n": // Scattered clouds
            return (.gray, .white.opacity(0.8))

        case "04d", "04n": // Broken clouds
            return (.gray, .white.opacity(0.6))

        case "09d", "09n": // Shower rain
            return (.blue, .gray)

        case "10d": // Rain day
            return (.blue, .cyan)
        case "10n": // Rain night
            return (.blue.opacity(0.7), .white)

        case "11d", "11n": // Thunderstorm
            return (.purple, .gray)

        case "13d", "13n": // Snow
            return (.white, .blue)

        case "50d", "50n": // Mist
            return (.gray, .white.opacity(0.8))

        default:
            return (.gray, .gray)
        }
    }
    
    func userKey(for email: String) -> String {
        return "recentCities_\(email)"
    }

    
    func filteredForecasts(for date: Date?) -> [ForecastItem] {
        guard let date = date else { return forecast }

        let calendar = Calendar.current
        return forecast.filter {
            calendar.isDate($0.fullDate, inSameDayAs: date)
        }
    }
    
    func findBestGolfTime(in forecasts: [ForecastItem]) -> (timeFormatted: String, temp: Int, condition: String, fullDate: Date)? {
        let calendar = Calendar.current
        let allowedCodes: Set<String> = ["01d", "02d", "03d", "04d", "50d"] // still avoid rain etc.
        let idealWindRange = 0...20
        let idealHumidityRange = 30...70

        // Step 1: Filter only viable forecasts
        let filtered = forecasts.filter {
            let hour = calendar.component(.hour, from: $0.fullDate)
            return (9...19).contains(hour) &&
                   allowedCodes.contains($0.iconCode) &&
                   idealWindRange.contains(Int($0.windSpeed)) &&
                   idealHumidityRange.contains($0.humidity)
        }

        // Step 2: Score each forecast
        func score(for item: ForecastItem) -> Int {
            var score = 0

            switch item.iconCode {
            case "01d": score += 100 // full sun
            case "02d": score += 80  // few clouds
            case "03d": score += 60  // scattered clouds
            case "04d": score += 40  // broken clouds
            case "50d": score += 20  // mist
            default: score += 0
            }

            // Favor temperature close to 20°C
            let tempPenalty = abs(item.temp - 20)
            score -= tempPenalty

            return score
        }

        let best = filtered.max(by: { score(for: $0) < score(for: $1) })

        guard let option = best else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE HH:mm"

        return (
            formatter.string(from: option.fullDate),
            option.temp,
            conditionText(for: option.iconCode),
            option.fullDate
        )
    }




    func conditionText(for code: String) -> String {
        switch code {
        case "01d": return "Clear sky"
        case "02d": return "Few clouds"
        case "03d": return "Scattered clouds"
        case "04d": return "Broken clouds"
        case "50d": return "Misty"
        default: return "Mixed"
        }
    }

    func isBestSlot(_ item: ForecastItem, comparedTo bestSlot: (timeFormatted: String, temp: Int, condition: String, fullDate: Date)?) -> Bool {
        guard let best = bestSlot else { return false }
        return Calendar.current.isDate(item.fullDate, equalTo: best.fullDate, toGranularity: .minute)
    }

}
