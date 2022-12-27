//
//  DayWeatherRepository.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import Foundation
import CoreLocation

struct DayWeatherRepository {
    let tempUnit: String = "celsius"
    private let dayWeatherPersistence: DayWeatherPersistence
    private let historicalWeatherPersistence: HistoricalWeatherPersistence
    init(dayWeatherPersistence: DayWeatherPersistence = DayWeatherPersistence(),  historicalWeatherPersistence: HistoricalWeatherPersistence = HistoricalWeatherPersistence()) {
        self.dayWeatherPersistence = dayWeatherPersistence
        self.historicalWeatherPersistence = historicalWeatherPersistence
    }
	// Two calls: get lat, long and then pass it to getCityName and then persist it
    func loadCurrentWeatherData() async throws {
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
            URLQueryItem(name: "timezone", value: TimeZone.current.identifier),
            URLQueryItem(name: "temperature_unit", value: tempUnit)
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
	
	func loadHistoricalData() async throws {
        try await historicalWeatherPersistence.removeAllEntries()
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = "archive-api.open-meteo.com"
		components.path = "/v1/era5"
		components.queryItems = [
			URLQueryItem(name: "latitude", value: "\(Coordinates.latitude)"),
			URLQueryItem(name: "longitude", value: "\(Coordinates.longitude)"),
			URLQueryItem(name: "start_date", value: "2022-11-18"), // TODO: get start_date from UI YYYY-MM-DD
			URLQueryItem(name: "end_date", value: "2022-12-18"), // TODO: get end_date from UI YYYY-MM-DD
			URLQueryItem(name: "daily", value: "weathercode,temperature_2m_max,temperature_2m_min"),
			URLQueryItem(name: "timezone", value: TimeZone.current.identifier),
			URLQueryItem(name: "temperature_unit", value: tempUnit)
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

		let optionalWeatherResponse = try? decoder.decode(HistoricalWeatherDecodable.self, from: data)
		if let weatherResponse = optionalWeatherResponse {
			print("Optional Weather: \(weatherResponse.daily.temperature_2m_max)")
			await historicalWeatherPersistence.addHistoricalWeather(from: weatherResponse, city: "City", country: "country")
		}
		
	}
}
