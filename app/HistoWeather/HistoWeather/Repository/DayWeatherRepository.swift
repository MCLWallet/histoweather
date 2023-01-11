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

	//    TODO: what if no connection and no permission
	//		TODO: what if connection but permission
	//		TODO: what if no connection but permission
	// Two calls: get lat, long and then pass it to getCityName and then persist it
	func loadCurrentWeatherData(tempUnit: String) async throws {
        try await dayWeatherPersistence.removeAllDayWeather()

        var city: String = "N/A"
        var country: String = "N/A"
		
		try await city = CLGeocoder().reverseGeocodeLocation(self.location).first?.locality ?? "N/A"
		try await country = CLGeocoder().reverseGeocodeLocation(self.location).first?.country ?? "N/A"
		self.locationTitle = "\(city)"
		
		print("loadCurrentWeatherData lat: \(self.location.coordinate.latitude)")
		print("loadCurrentWeatherData long: \(self.location.coordinate.longitude)")
		print("loadCurrentWeatherData city: \(city)")
		
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
            await dayWeatherPersistence.addDayWeather(from: weatherResponse, city: city, country: country)
        }
		print("DayWeatherRepository lat: \(self.location.coordinate.latitude)")
		print("DayWeatherRepository long: \(self.location.coordinate.longitude)")
		print("DayWeatherRepository city: \(city)")
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
            URLQueryItem(name: "start_date", value: "\(startYear)" + monthDay), // TODO: get start_date from UI YYYY-MM-DD
            URLQueryItem(name: "end_date", value: "\(endYear)" + monthDay), // TODO: get end_date from UI YYYY-MM-DD
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
    
	func loadHistoricalDataHourly(tempUnit: String, startDate: Date, endDate: Date) async throws {
        try await historicalGraphPersistence.removeAllEntries()
        
        var city: String = "N/A"
        var country: String = "N/A"
		try await city = CLGeocoder().reverseGeocodeLocation(self.location).first?.locality ?? "N/A"
		try await country = CLGeocoder().reverseGeocodeLocation(self.location).first?.country ?? "N/A"
		self.locationTitle = "\(city)"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "archive-api.open-meteo.com"
        components.path = "/v1/archive"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "longitude", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "start_date", value: convertDateToString(from: startDate)),
            URLQueryItem(name: "end_date", value: convertDateToString(from: endDate)),
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
            await historicalGraphPersistence.addHistoricalGraph(historicalGraphDecodable: weatherResponse, city: city, country: country)
        }
    }
}
