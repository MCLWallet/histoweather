//
//  LocationSearchWebservice.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 04.12.22.
//

import Foundation

enum NetworkError: Error {
	case badURL
	case badID
}

class LocationSearchWebservice {
	
	func getLocations(searchTerm: String) async throws -> [Location] {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "geocoding-api.open-meteo.com"
		components.path = "/v1/search"
		components.queryItems = [
			URLQueryItem(name: "name", value: searchTerm)
		]
		
		guard let url = components.url else {
			throw NetworkError.badURL
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			throw NetworkError.badID
		}
		
		let locationResponse = try? JSONDecoder().decode(LocationResponse.self, from: data)
		return locationResponse?.locations ?? []
	}
}
