//
//  DayWeatherRepository.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import Foundation
import CoreLocation

struct DayWeatherRepository {
    private let dayWeatherPersistence: DayWeatherPersistence
    init(dayWeatherPersistence: DayWeatherPersistence = DayWeatherPersistence()) {
        self.dayWeatherPersistence = dayWeatherPersistence
    }
    func loadData() async throws {
        try await dayWeatherPersistence.removeAllFriends()
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(Coordinates.latitude)"),
            URLQueryItem(name: "longitude", value: "\(Coordinates.longitude)"),
            URLQueryItem(name: "daily", value: "weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,windspeed_10m_max"),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "timezone", value: TimeZone.current.identifier)
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
        print("\(url)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let optionalWeatherResponse = try? decoder.decode(Weather.self, from: data)
        if let weatherResponse = optionalWeatherResponse {
            await dayWeatherPersistence.addDayWeather(from: weatherResponse)
        }
    }
}

public struct Weather: Decodable {
    let daily: Daily
    let elevation: Double
    let latitude: Double
    let longitude: Double
    let current_weather: CurrentWeather
}

struct CurrentWeather: Decodable {
    let time: Date
    let temperature: Double
    let windspeed: Double
    let winddirection: Double
    let weathercode: Int16
}

struct Daily: Decodable {
    let time: [String]
    let weathercode: [Int16]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let sunrise: [Date]
    let sunset: [Date]
    let precipitation_sum: [Double]
    let windspeed_10m_max: [Double]
}
