//
//  DayWeatherRepository.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import Foundation
import CoreLocation

class DayWeatherRepository {
    
    @Published var location: CLLocation
    
    private let dayWeatherPersistence: DayWeatherPersistence
    private let historicalWeatherPersistence: HistoricalWeatherPersistence
    private let historicalPersistenceGraph: HistoricalPersistenceGraph
    
    init(dayWeatherPersistence: DayWeatherPersistence = DayWeatherPersistence(), historicalWeatherPersistence: HistoricalWeatherPersistence = HistoricalWeatherPersistence(), historicalPersistenceGraph: HistoricalPersistenceGraph = HistoricalPersistenceGraph()) {
        
        self.dayWeatherPersistence = dayWeatherPersistence
        self.historicalWeatherPersistence = historicalWeatherPersistence
        self.historicalPersistenceGraph = historicalPersistenceGraph
        self.location = CLLocation(latitude: LocationManager.shared.userLocation?.coordinate.latitude ?? 48.20849, longitude: LocationManager.shared.userLocation?.coordinate.longitude ?? 16.37208)
    }
    
	// Two calls: get lat, long and then pass it to getCityName and then persist it
	func loadCurrentWeatherData(tempUnit: String) async throws {
        try await dayWeatherPersistence.removeAllFriends()
        
        var city: String = "N/A"
        var country: String = "N/A"
        
        CLGeocoder().reverseGeocodeLocation(self.location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return }
            city = placemark.locality! // This is the city name
            country = placemark.country!
            print("\(city)")
            print("\(country)")
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "daily", value: "weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,windspeed_10m_max"),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "timezone", value: TimeZone.current.identifier),
            URLQueryItem(name: "temperature_unit", value: tempUnit)
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
//        print("\(url)")
        
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
            await dayWeatherPersistence.addDayWeather(from: weatherResponse, city: city, country: country)
        }
    }
	
	func loadHistoricalData(tempUnit: String) async throws {
        try await historicalWeatherPersistence.removeAllEntries()
		
        var city: String = "N/A"
        var country: String = "N/A"
        CLGeocoder().reverseGeocodeLocation(self.location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return }
            city = placemark.locality! // This is the city name
            country = placemark.country!
//            print("\(city)")
//            print("\(country)")
        }
        
		var components = URLComponents()
		components.scheme = "https"
		components.host = "archive-api.open-meteo.com"
		components.path = "/v1/era5"
		components.queryItems = [
			URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"),
			URLQueryItem(name: "start_date", value: "2000-11-18"), // TODO: get start_date from UI YYYY-MM-DD
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
            await historicalWeatherPersistence.addHistoricalWeather(historicalWeatherDecodable: weatherResponse, city: city, country: country)
		}
	}
    
    func loadHistoricalDataHourly(tempUnit: String, hourlyParameter: String) async throws {
        try await historicalWeatherPersistence.removeAllEntries()
        
        var city: String = "N/A"
        var country: String = "N/A"
        CLGeocoder().reverseGeocodeLocation(self.location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return }
            city = placemark.locality! // This is the city name
            country = placemark.country!
//            print("\(city)")
//            print("\(country)")
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "archive-api.open-meteo.com"
        components.path = "/v1/archive"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "start_date", value: "2000-12-18"), // TODO: get start_date from UI YYYY-MM-DD
            URLQueryItem(name: "end_date", value: "2022-12-18"), // TODO: get end_date from UI YYYY-MM-DD
            URLQueryItem(name: "hourly", value: "temperature_2m,rain,windspeed_10m"),
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

        let optionalWeatherResponse = try? decoder.decode(HistoricalGraphDecodable.self, from: data)
        if let weatherResponse = optionalWeatherResponse {
            await historicalPersistenceGraph.addHistoricalGraph(historicalGraphDecodable: weatherResponse, city: city, country: country)
        }
    }
}
