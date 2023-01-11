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
	@Published var locationTitle: String
    
    private let dayWeatherPersistence: DayWeatherPersistence
    private let historicalWeatherPersistence: HistoricalWeatherPersistence
    private let historicalGraphPersistence: HistoricalGraphPersistence
    
    init(dayWeatherPersistence: DayWeatherPersistence = DayWeatherPersistence(), historicalWeatherPersistence: HistoricalWeatherPersistence = HistoricalWeatherPersistence(), historicalGraphPersistence: HistoricalGraphPersistence = HistoricalGraphPersistence()) {
        
        self.dayWeatherPersistence = dayWeatherPersistence
        self.historicalWeatherPersistence = historicalWeatherPersistence
        self.historicalGraphPersistence = historicalGraphPersistence
        self.location = CLLocation(latitude: LocationManager.shared.userLocation.coordinate.latitude, longitude: LocationManager.shared.userLocation.coordinate.longitude)
		self.locationTitle = "Vienna"
    }
	
	func updateLocation(location: CLLocation) {
		self.location = location
	}
	
	func updateLocationTitle(locationTitle: String) {
		self.locationTitle = locationTitle
	}

	func loadCurrentWeatherData(tempUnit: String) async throws {
        try await dayWeatherPersistence.removeAllDayWeather()

        var city: String = "N/A"
        var country: String = "N/A"
		
		try await city = CLGeocoder().reverseGeocodeLocation(self.location).first?.locality ?? "N/A"
		try await country = CLGeocoder().reverseGeocodeLocation(self.location).first?.country ?? "N/A"
		self.locationTitle = "\(city)"
		
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.open-meteo.com"
        components.path = "/v1/forecast"
        components.queryItems = [
			URLQueryItem(name: "latitude", value: "\(self.location.coordinate.latitude)"),
			URLQueryItem(name: "longitude", value: "\(self.location.coordinate.longitude)"),
            URLQueryItem(name: "daily", value: "weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,windspeed_10m_max"),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "timezone", value: TimeZone.current.identifier),
            URLQueryItem(name: "temperature_unit", value: tempUnit)
        ]
        
        guard let url = components.url else {
            throw NetworkError.badURL
        }
        
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
	
	func loadHistoricalData(tempUnit: String, startYear: Int, endYear: Int) async throws {
        try await historicalWeatherPersistence.removeAllEntries()
		
        var city: String = "N/A"
        var country: String = "N/A"
		try await city = CLGeocoder().reverseGeocodeLocation(self.location).first?.locality ?? "N/A"
		try await country = CLGeocoder().reverseGeocodeLocation(self.location).first?.country ?? "N/A"
		self.locationTitle = "\(city)"
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: -6, to: Date())!
        let formatter = DateFormatter()
        formatter.dateFormat = "-MM-DD"
        let monthDay = formatter.string(from: date)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "archive-api.open-meteo.com"
        components.path = "/v1/era5"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "start_date", value: "\(startYear)" + monthDay),
            URLQueryItem(name: "end_date", value: "\(endYear)" + monthDay), 
            URLQueryItem(name: "daily", value: "weathercode,temperature_2m_max,temperature_2m_min"),
            URLQueryItem(name: "timezone", value: TimeZone.current.identifier),
            URLQueryItem(name: "temperature_unit", value: tempUnit)
        ]
		
		guard let url = components.url else {
			throw NetworkError.badURL
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw NetworkError.badID
		}

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-mm-dd"
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(dateFormatter)

		let optionalWeatherResponse = try? decoder.decode(HistoricalWeatherDecodable.self, from: data)
		if let weatherResponse = optionalWeatherResponse {
            await historicalWeatherPersistence.addHistoricalWeather(historicalWeatherDecodable: weatherResponse, city: city, country: country)
		}
	}
    
    func loadHistoricalDataHourly(tempUnit: String, startDate: Date, endDate: Date) async throws {
        try await historicalGraphPersistence.removeAllEntries()
        
        var city: String = "N/A"
        var country: String = "N/A"
        try await city = CLGeocoder().reverseGeocodeLocation(self.location).first?.locality ?? "N/A"
        try await country = CLGeocoder().reverseGeocodeLocation(self.location).first?.country ?? "N/A"
        self.locationTitle = "\(city)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        var componentsDay1 = URLComponents()
        componentsDay1.scheme = "https"
        componentsDay1.host = "archive-api.open-meteo.com"
        componentsDay1.path = "/v1/archive"
        componentsDay1.queryItems = [
            URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "start_date", value: convertDateToString(from: startDate)),
            URLQueryItem(name: "end_date", value: convertDateToString(from: startDate)),
            URLQueryItem(name: "hourly", value: "temperature_2m,rain,windspeed_10m"),
            URLQueryItem(name: "timezone", value: TimeZone.current.identifier),
            URLQueryItem(name: "temperature_unit", value: tempUnit)
        ]
        
        guard let urlDay1 = componentsDay1.url else {
            throw NetworkError.badURL
        }
        let (dataDay1, responseDay1) = try await URLSession.shared.data(from: urlDay1)
        
        guard (responseDay1 as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        var componentsDay2 = URLComponents()
        componentsDay2.scheme = "https"
        componentsDay2.host = "archive-api.open-meteo.com"
        componentsDay2.path = "/v1/archive"
        componentsDay2.queryItems = [
            URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "start_date", value: convertDateToString(from: endDate)),
            URLQueryItem(name: "end_date", value: convertDateToString(from: endDate)),
            URLQueryItem(name: "hourly", value: "temperature_2m,rain,windspeed_10m"),
            URLQueryItem(name: "timezone", value: TimeZone.current.identifier),
            URLQueryItem(name: "temperature_unit", value: tempUnit)
        ]
        
        guard let urlDay2 = componentsDay2.url else {
            throw NetworkError.badURL
        }
    
        let (dataDay2, responseDay2) = try await URLSession.shared.data(from: urlDay2)
        guard (responseDay2 as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badID
        }
        
        let optionalWeatherResponseDay1 = try? decoder.decode(HistoricalGraphDecodable.self, from: dataDay1)
        let optionalWeatherResponseDay2 = try? decoder.decode(HistoricalGraphDecodable.self, from: dataDay2)
        
        if let weatherResponseDay1 = optionalWeatherResponseDay1, let weatherResponseDay2 = optionalWeatherResponseDay2 {
            await historicalGraphPersistence.addHistoricalGraph(weatherResponseDay1: weatherResponseDay1.hourly, weatherResponseDay2: weatherResponseDay2.hourly, city: city, country: country)
        }
    }}
